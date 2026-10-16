import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

/// Rounded pill: filled primary with white text when selected, white with a
/// subtle shadow otherwise. Used for the task filters.
class AppChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AppChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusChip);
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: radius,
        boxShadow: isSelected ? AppShadows.softStrong : AppShadows.soft,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.xl,
              vertical: AppSizes.s + AppSizes.xxs,
            ),
            child: Text(
              label,
              style: isSelected
                  ? AppTextStyles.chip.copyWith(color: AppColors.white)
                  : AppTextStyles.chip,
            ),
          ),
        ),
      ),
    );
  }
}
