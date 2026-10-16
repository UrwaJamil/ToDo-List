import 'package:flutter/material.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_icons.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

/// Shown on Forgot Password after a reset request. The message is the same
/// whether or not the account exists (email enumeration protection).
class ResetLinkSentPanel extends StatelessWidget {
  final VoidCallback onBackToLogin;

  const ResetLinkSentPanel({super.key, required this.onBackToLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.l),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(AppIcons.mailSent, color: AppColors.successDark),
              const SizedBox(width: AppSizes.m),
              Expanded(
                child: Text(
                  AppStrings.resetLinkSent,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xxl),
        CustomButton(
          label: AppStrings.backToLogin,
          gradient: AppColors.primaryGradient,
          onPressed: onBackToLogin,
        ),
      ],
    );
  }
}
