import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

/// Tinted summary tile: icon in a rounded square, big number, label and a
/// small arrow. Tappable when [onTap] is set.
class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  /// Icon / arrow color.
  final Color color;

  /// Card background: a flat [tint], or a [tintGradient] if given.
  final Color tint;
  final Gradient? tintGradient;

  /// Background of the rounded square behind the icon.
  final Color iconBoxColor;

  /// Label color (the number is always [AppColors.statText]).
  final Color? labelColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.tint = AppColors.surface,
    this.tintGradient,
    this.iconBoxColor = AppColors.surface,
    this.labelColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusTaskCard);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tint,
        gradient: tintGradient,
        borderRadius: radius,
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.statIconBox,
                  height: AppSizes.statIconBox,
                  decoration: BoxDecoration(
                    color: iconBoxColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  child: Icon(icon, color: color, size: AppSizes.iconM),
                ),
                const SizedBox(height: AppSizes.s),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$count',
                    style: AppTextStyles.statNumber.copyWith(
                      color: AppColors.statText,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xxs),
                // Scales down rather than truncating on narrow phones.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: labelColor == null
                        ? AppTextStyles.statLabel
                        : AppTextStyles.statLabel.copyWith(color: labelColor),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    AppIcons.statArrow,
                    size: AppSizes.iconXs,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
