import 'package:flutter/material.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_icons.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../controllers/auth_controller.dart';

/// Suffix of the Sign-Up email field: a small spinner while checking, a
/// green check when available, a red cross when taken, otherwise nothing.
class EmailStatusIndicator extends StatelessWidget {
  final EmailStatus status;

  const EmailStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case EmailStatus.checking:
        return const Padding(
          padding: EdgeInsets.all(AppSizes.m + AppSizes.xxs),
          child: SizedBox.square(
            dimension: AppSizes.spinnerSmall,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      case EmailStatus.available:
        return const Icon(AppIcons.emailAvailable, color: AppColors.success);
      case EmailStatus.taken:
        return const Icon(AppIcons.emailTaken, color: AppColors.error);
      case EmailStatus.idle:
      case EmailStatus.error:
        return const SizedBox.shrink();
    }
  }
}
