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
import '../../../shared/widgets/password_requirements.dart';
import '../../../shared/widgets/password_text_field.dart';
import '../controllers/auth_controller.dart';
import 'widgets/email_status_indicator.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: AppStrings.createAccount,
      subtitle: AppStrings.signupSubtitle,
      bottomLink: AuthSwitchLink(
        question: AppStrings.haveAccount,
        action: AppStrings.login,
        onTap: controller.goToLogin,
      ),
      form: Form(
        key: controller.signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: controller.signupNameController,
              label: AppStrings.nameLabel,
              hint: AppStrings.nameHint,
              prefixIcon: AppIcons.person,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: controller.validateName,
            ),
            const SizedBox(height: AppSizes.l),
            Obx(() {
              final status = controller.emailStatus.value;
              return CustomTextField(
                controller: controller.signupEmailController,
                label: AppStrings.emailLabel,
                hint: AppStrings.emailHint,
                prefixIcon: AppIcons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: controller.validateSignupEmail,
                suffixIcon: EmailStatusIndicator(status: status),
                helperText: status == EmailStatus.available
                    ? AppStrings.emailAvailable
                    : null,
                helperColor: AppColors.successDark,
              );
            }),
            const SizedBox(height: AppSizes.l),
            PasswordTextField(
              controller: controller.signupPasswordController,
              label: AppStrings.passwordLabel,
              hint: AppStrings.passwordHint,
              isObscured: controller.obscurePassword,
              onToggleVisibility: controller.togglePasswordVisibility,
              validator: controller.validateSignupPassword,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.s),
            Obx(
              () => PasswordRequirements(
                password: controller.signupPassword.value,
              ),
            ),
            const SizedBox(height: AppSizes.l),
            PasswordTextField(
              controller: controller.signupConfirmPasswordController,
              label: AppStrings.confirmPasswordLabel,
              hint: AppStrings.confirmPasswordHint,
              isObscured: controller.obscureConfirmPassword,
              onToggleVisibility: controller.toggleConfirmPasswordVisibility,
              validator: controller.validateConfirmPassword,
              onSubmitted: (_) => controller.signUp(),
            ),
            const SizedBox(height: AppSizes.xxl),
            Obx(
              () => CustomButton(
                label: AppStrings.signUp,
                gradient: AppColors.primaryGradient,
                isLoading: controller.isLoading.value,
                onPressed: controller.isSignupBlocked
                    ? null
                    : controller.signUp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
