import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/constants/app_icons.dart';
import 'package:todo_app/app/constants/app_strings.dart';
import 'package:todo_app/app/theme/app_theme.dart';
import 'package:todo_app/data/services/auth_service.dart';
import 'package:todo_app/data/services/notification_service.dart';
import 'package:todo_app/modules/auth/controllers/auth_controller.dart';
import 'package:todo_app/modules/auth/controllers/forgot_password_controller.dart';
import 'package:todo_app/modules/auth/views/forgot_password_view.dart';
import 'package:todo_app/modules/auth/views/login_view.dart';
import 'package:todo_app/modules/auth/views/signup_view.dart';
import 'package:todo_app/shared/widgets/app_logo.dart';
import 'package:todo_app/shared/widgets/auth_header.dart';
import 'package:todo_app/shared/widgets/custom_button.dart';

/// Auth screens never reach notifications in these tests (no login happens).
class _FakeNotificationService implements NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Never touches Firebase. Availability and reset requests are faked; every
/// other call fails validation before reaching the service.
class _FakeAuthService implements AuthService {
  bool emailAvailable = true;
  final List<String> checkedEmails = [];

  @override
  Future<bool> isEmailAvailable(String email) async {
    checkedEmails.add(email);
    return emailAvailable;
  }

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

late _FakeAuthService _service;

Widget _app(Widget page, {double textScale = 1}) {
  return GetMaterialApp(
    theme: AppTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: page,
  );
}

Finder _fieldWithHint(String hint) => find.widgetWithText(TextFormField, hint);

void main() {
  setUp(() {
    final view = TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .views
        .first;
    view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    _service = _FakeAuthService();
    Get.put(AuthController(_service, _FakeNotificationService()));
    Get.put(ForgotPasswordController(_service));
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view
      ..resetPhysicalSize()
      ..resetDevicePixelRatio()
      ..resetViewInsets();
    Get.reset();
  });

  for (final entry in {
    'login': const LoginView(),
    'signup': const SignupView(),
  }.entries) {
    testWidgets('${entry.key}: no overflow at 360px, with errors shown', (
      tester,
    ) async {
      await tester.pumpWidget(_app(entry.value));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Submit the empty form so every validation message appears.
      await tester.ensureVisible(find.byType(CustomButton));
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsWidgets);
    });
  }

  for (final entry in {
    'login': const LoginView(),
    'signup': const SignupView(),
    'forgot password': const ForgotPasswordView(),
  }.entries) {
    testWidgets('${entry.key}: no overflow with keyboard open', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpWidget(_app(entry.value));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('${entry.key}: no overflow with large text', (tester) async {
      await tester.pumpWidget(_app(entry.value, textScale: 1.3));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  group('auth header is centered', () {
    final screens = {
      'login': const LoginView(),
      'signup': const SignupView(),
      'forgot password': const ForgotPasswordView(),
    };

    for (final entry in screens.entries) {
      for (final (width, scale) in [(360.0, 1.0), (360.0, 1.3), (320.0, 1.3)]) {
        testWidgets('${entry.key} at ${width.toInt()}px, text x$scale', (
          tester,
        ) async {
          tester.view.physicalSize = Size(width, 640);
          await tester.pumpWidget(_app(entry.value, textScale: scale));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          final header = find.byType(AuthHeader);
          final centerX = tester.getRect(header).center.dx;
          final items = [
            find.descendant(of: header, matching: find.byType(AppLogo)),
            find.descendant(
              of: header,
              matching: find.text(AppStrings.appName),
            ),
            find.descendant(
              of: header,
              matching: find.text(AppStrings.appTagline),
            ),
          ];
          for (final item in items) {
            expect(tester.getRect(item).center.dx, closeTo(centerX, 0.5));
          }

          // When the tagline wraps on narrow screens, each line is centred.
          final tagline = tester.widget<Text>(items.last);
          expect(tagline.textAlign, TextAlign.center);
        });
      }
    }
  });

  group('login', () {
    testWidgets('shows Forgot password and accepts a short password', (
      tester,
    ) async {
      await tester.pumpWidget(_app(const LoginView()));
      expect(find.text(AppStrings.forgotPassword), findsOneWidget);

      await tester.enterText(_fieldWithHint(AppStrings.passwordHint), 'abc');
      await tester.pump();
      expect(find.text(AppStrings.passwordTooWeak), findsNothing);
      expect(find.text(AppStrings.passwordRequired), findsNothing);
    });
  });

  group('forgot password', () {
    testWidgets('requires a valid email', (tester) async {
      await tester.pumpWidget(_app(const ForgotPasswordView()));
      await tester.tap(find.text(AppStrings.sendResetLink));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.resetLinkSent), findsNothing);
    });

    testWidgets('shows the generic success message and Back to Login', (
      tester,
    ) async {
      await tester.pumpWidget(_app(const ForgotPasswordView()));
      await tester.enterText(
        _fieldWithHint(AppStrings.emailHint),
        'someone@example.com',
      );
      await tester.tap(find.text(AppStrings.sendResetLink));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.resetLinkSent), findsOneWidget);
      expect(find.text(AppStrings.backToLogin), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('signup', () {
    testWidgets('password checklist turns green rule by rule', (tester) async {
      await tester.pumpWidget(_app(const SignupView()));
      expect(find.text(AppStrings.ruleMinLength), findsOneWidget);
      expect(find.text(AppStrings.ruleLetter), findsOneWidget);
      expect(find.text(AppStrings.ruleDigit), findsOneWidget);
      expect(find.byIcon(AppIcons.ruleMet), findsNothing);

      final password = _fieldWithHint(AppStrings.passwordHint);
      await tester.enterText(password, 'abc');
      await tester.pump();
      expect(find.byIcon(AppIcons.ruleMet), findsOneWidget);

      await tester.enterText(password, 'abcdefg1');
      await tester.pump();
      expect(find.byIcon(AppIcons.ruleMet), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('available email shows helper text after the debounce', (
      tester,
    ) async {
      await tester.pumpWidget(_app(const SignupView()));
      await tester.enterText(
        _fieldWithHint(AppStrings.emailHint),
        'New@Example.com',
      );
      await tester.pump();
      // Checking: spinner shown, Sign-Up blocked, no request yet.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<CustomButton>(find.byType(CustomButton)).onPressed,
        isNull,
      );
      expect(_service.checkedEmails, isEmpty);

      await tester.pump(AuthController.emailCheckDelay);
      await tester.pump();
      expect(_service.checkedEmails, ['New@Example.com']);
      expect(find.text(AppStrings.emailAvailable), findsOneWidget);
      expect(find.byIcon(AppIcons.emailAvailable), findsOneWidget);
      expect(
        tester.widget<CustomButton>(find.byType(CustomButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('taken email shows an error and blocks Sign-Up', (
      tester,
    ) async {
      _service.emailAvailable = false;
      await tester.pumpWidget(_app(const SignupView()));
      await tester.enterText(
        _fieldWithHint(AppStrings.emailHint),
        'used@example.com',
      );
      await tester.pump(AuthController.emailCheckDelay);
      await tester.pump();

      expect(find.text(AppStrings.emailTaken), findsOneWidget);
      expect(find.byIcon(AppIcons.emailTaken), findsOneWidget);
      expect(
        tester.widget<CustomButton>(find.byType(CustomButton)).onPressed,
        isNull,
      );
    });

    testWidgets('invalid email format is never checked', (tester) async {
      await tester.pumpWidget(_app(const SignupView()));
      await tester.enterText(_fieldWithHint(AppStrings.emailHint), 'not-email');
      await tester.pump(AuthController.emailCheckDelay);
      await tester.pump();

      expect(_service.checkedEmails, isEmpty);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
