import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/constants/app_strings.dart';
import '../../app/theme/app_text_styles.dart';

/// Small colored pill used for status, priority and "overdue" labels.
///
/// The background is a light tint of [color]; the text and icon use the
/// darker [textColor] so they stay readable. When [filled] (e.g. the selected
/// priority) the pill is solid [textColor] with white text.
class InfoBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  /// Exact light background; defaults to a light tint of [color].
  final Color? tintColor;
  final IconData? icon;
  final bool filled;

  const InfoBadge({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    this.tintColor,
    this.icon,
    this.filled = false,
  });

  /// Red "Overdue" badge shown on task cards and the details screen.
  const InfoBadge.overdue({super.key})
    : label = AppStrings.overdue,
      color = AppColors.overdue,
      textColor = AppColors.overdueText,
      tintColor = null,
      icon = AppIcons.overdue,
      filled = false;

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? AppColors.white : textColor;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s + AppSizes.xxs,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: filled ? textColor : tintColor ?? color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSizes.radiusChip),
        border: Border.all(
          color: filled ? textColor : color.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconXs, color: foreground),
            const SizedBox(width: AppSizes.xs),
          ],
          Text(label, style: AppTextStyles.badge.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
