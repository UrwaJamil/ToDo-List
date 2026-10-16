import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import 'custom_button.dart';
import 'empty_illustration.dart';

/// Illustrated clipboard + title + message, with an optional action button.
/// Used for "No tasks yet", "No matching tasks", empty calendar days and the
/// error state; [icon] is the small badge on the clipboard.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.color = AppColors.primary,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xxxl,
          vertical: AppSizes.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyIllustration(badgeIcon: icon, badgeColor: color),
            const SizedBox(height: AppSizes.l),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppSizes.s),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSizes.xxl),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.emptyActionMaxWidth,
                ),
                child: CustomButton(
                  label: actionLabel!,
                  icon: actionIcon,
                  color: color,
                  onPressed: onAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
