import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_strings.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../app/utils/validators.dart';
import '../../../data/services/auth_service.dart';

/// Sends a password reset email. Lives only while FORGOT_PASSWORD is open.
class ForgotPasswordController extends GetxController {
  ForgotPasswordController(this._authService);

  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  /// True once the request succeeded; the view then shows the success panel.
  final RxBool isEmailSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Login passes whatever was already typed in its email field.
    final initialEmail = Get.arguments;
    if (initialEmail is String) emailController.text = initialEmail;
  }

  String? validateEmail(String? value) => Validators.email(value);

  Future<void> sendResetLink() async {
    if (isLoading.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      await _authService.sendPasswordReset(emailController.text.trim());
      // Same result whether or not the account exists (enumeration protection).
      isEmailSent.value = true;
    } on AuthFailure catch (e) {
      AppSnackbar.error(e.message);
    } catch (_) {
      AppSnackbar.error(AppStrings.errorGeneric);
    } finally {
      isLoading.value = false;
    }
  }

  void backToLogin() => Get.back(closeOverlays: true);

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
