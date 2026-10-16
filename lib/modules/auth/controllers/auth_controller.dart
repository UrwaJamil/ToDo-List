import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_strings.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../app/utils/validators.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/widgets/confirmation_dialog.dart';

/// Result of the live "is this email already registered?" check on Sign-Up.
enum EmailStatus { idle, checking, available, taken, error }

/// Handles login, sign-up, logout and form validation for the auth screens.
class AuthController extends GetxController {
  AuthController(this._authService, this._notificationService);

  final AuthService _authService;
  final NotificationService _notificationService;

  static const Duration emailCheckDelay = Duration(milliseconds: 600);

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  /// Mirrors of the Sign-Up email / password fields, so workers and Obx
  /// widgets (availability check, password checklist) can react to typing.
  final RxString signupEmail = ''.obs;
  final RxString signupPassword = ''.obs;
  final Rx<EmailStatus> emailStatus = EmailStatus.idle.obs;

  final List<Worker> _workers = [];

  /// Sign-Up is blocked while the email is being checked or is taken.
  bool get isSignupBlocked =>
      emailStatus.value == EmailStatus.checking ||
      emailStatus.value == EmailStatus.taken;

  @override
  void onInit() {
    super.onInit();
    signupEmailController.addListener(
      () => signupEmail.value = signupEmailController.text.trim(),
    );
    signupPasswordController.addListener(
      () => signupPassword.value = signupPasswordController.text,
    );
    _workers
      // Runs on every keystroke: forget the old result straight away.
      ..add(ever(signupEmail, _onSignupEmailChanged))
      // Runs once typing pauses: hit Firestore at most once per pause.
      ..add(
        debounce(signupEmail, _checkEmailAvailability, time: emailCheckDelay),
      );
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();

  // ---------------------------------------------------------------- validation

  String? validateName(String? value) => Validators.name(value);

  String? validateEmail(String? value) => Validators.email(value);

  /// Sign-Up email: format first, then the result of the availability check.
  String? validateSignupEmail(String? value) {
    final formatError = Validators.email(value);
    if (formatError != null) return formatError;
    if (emailStatus.value == EmailStatus.taken) return AppStrings.emailTaken;
    return null;
  }

  String? validateLoginPassword(String? value) =>
      Validators.loginPassword(value);

  String? validateSignupPassword(String? value) =>
      Validators.signupPassword(value);

  String? validateConfirmPassword(String? value) =>
      Validators.confirmPassword(value, signupPasswordController.text);

  // -------------------------------------------------------- email availability

  void _onSignupEmailChanged(String email) {
    emailStatus.value = Validators.isValidEmail(email)
        ? EmailStatus.checking
        : EmailStatus.idle;
  }

  Future<void> _checkEmailAvailability(String email) async {
    if (!Validators.isValidEmail(email)) return;
    EmailStatus result;
    try {
      final available = await _authService.isEmailAvailable(email);
      result = available ? EmailStatus.available : EmailStatus.taken;
    } catch (_) {
      // Don't block Sign-Up; Firebase's email-already-in-use is the backstop.
      result = EmailStatus.error;
    }
    // Ignore a stale answer if the user kept typing while we waited.
    if (signupEmail.value == email) emailStatus.value = result;
  }

  // ------------------------------------------------------------------- actions

  Future<void> login() async {
    if (isLoading.value) return;
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      await _authService.login(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );
      _clearForms();
      Get.offAllNamed(Routes.MAIN);
      // Reminders are synced by Home; ask once now that a user is signed in.
      unawaited(_notificationService.requestPermission());
      AppSnackbar.success(AppStrings.loginSuccess);
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    } catch (_) {
      AppSnackbar.error(AppStrings.errorGeneric);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (isLoading.value || isSignupBlocked) return;
    if (!(signupFormKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      await _authService.signUp(
        name: signupNameController.text.trim(),
        email: signupEmailController.text.trim(),
        password: signupPasswordController.text,
      );
      _clearForms();
      Get.offAllNamed(Routes.MAIN);
      unawaited(_notificationService.requestPermission());
      AppSnackbar.success(AppStrings.signupSuccess);
    } on AuthFailure catch (e) {
      if (e.message == AppStrings.errorEmailInUse) {
        emailStatus.value = EmailStatus.taken;
      }
      AppSnackbar.error(e.message);
    } catch (_) {
      AppSnackbar.error(AppStrings.errorGeneric);
    } finally {
      isLoading.value = false;
    }
  }

  /// Asks for confirmation, signs out and returns to the login screen.
  Future<void> logout() async {
    final confirmed = await ConfirmationDialog.show(
      title: AppStrings.logout,
      message: AppStrings.logoutMessage,
      confirmText: AppStrings.logout,
    );
    if (!confirmed) return;

    try {
      // The next user on this phone must not get this user's reminders.
      await _notificationService.cancelAll();
      await _authService.logout();
      Get.offAllNamed(Routes.LOGIN);
      AppSnackbar.success(AppStrings.logoutSuccess);
    } catch (_) {
      AppSnackbar.error(AppStrings.errorGeneric);
    }
  }

  // ---------------------------------------------------------------- navigation

  void goToSignup() {
    _resetVisibility();
    Get.toNamed(Routes.SIGNUP);
  }

  void goToLogin() {
    _resetVisibility();
    Get.back(closeOverlays: true);
  }

  /// Opens Forgot Password, pre-filling whatever is typed in the login email.
  void goToForgotPassword() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(
      Routes.FORGOT_PASSWORD,
      arguments: loginEmailController.text.trim(),
    );
  }

  void _resetVisibility() {
    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
  }

  void _clearForms() {
    for (final controller in [
      loginEmailController,
      loginPasswordController,
      signupNameController,
      signupEmailController,
      signupPasswordController,
      signupConfirmPasswordController,
    ]) {
      controller.clear();
    }
    _resetVisibility();
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    super.onClose();
  }
}
