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
import '../controllers/forgot_password_controller.dart';
import 'widgets/reset_link_sent_panel.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: AppStrings.resetPasswordTitle,
      subtitle: AppStrings.resetPasswordSubtitle,
      bottomLink: AuthSwitchLink(
        question: AppStrings.rememberPassword,
        action: AppStrings.login,
        onTap: controller.backToLogin,
      ),
      form: Obx(
        () => controller.isEmailSent.value
            ? ResetLinkSentPanel(onBackToLogin: controller.backToLogin)
            : Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: controller.emailController,
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      prefixIcon: AppIcons.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: controller.validateEmail,
                      onSubmitted: (_) => controller.sendResetLink(),
                    ),
                    const SizedBox(height: AppSizes.xxl),
                    CustomButton(
                      label: AppStrings.sendResetLink,
                      gradient: AppColors.primaryGradient,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.sendResetLink,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
