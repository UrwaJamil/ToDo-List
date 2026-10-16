import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../shared/widgets/auth_page_layout.dart';
import '../../../shared/widgets/auth_switch_link.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/password_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: AppStrings.welcomeBack,
      subtitle: AppStrings.loginSubtitle,
      bottomLink: AuthSwitchLink(
        question: AppStrings.noAccount,
        action: AppStrings.signUp,
        onTap: controller.goToSignup,
      ),
      form: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: controller.loginEmailController,
              label: AppStrings.emailLabel,
              hint: AppStrings.emailHint,
              prefixIcon: AppIcons.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: controller.validateEmail,
            ),
            const SizedBox(height: AppSizes.l),
            PasswordTextField(
              controller: controller.loginPasswordController,
              label: AppStrings.passwordLabel,
              hint: AppStrings.passwordHint,
              isObscured: controller.obscurePassword,
              onToggleVisibility: controller.togglePasswordVisibility,
              validator: controller.validateLoginPassword,
              onSubmitted: (_) => controller.login(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: controller.goToForgotPassword,
                // Color and font come from the TextButton theme.
                child: const Text(AppStrings.forgotPassword),
              ),
            ),
            const SizedBox(height: AppSizes.s),
            Obx(
              () => CustomButton(
                label: AppStrings.login,
                gradient: AppColors.primaryGradient,
                isLoading: controller.isLoading.value,
                onPressed: controller.login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
