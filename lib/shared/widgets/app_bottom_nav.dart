import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

/// Data for one [AppBottomNav] tab.
class BottomNavEntry {
  final IconData icon;
  final String label;

  const BottomNavEntry({required this.icon, required this.label});
}

/// Floating white bottom bar with rounded top corners and a soft shadow.
class AppBottomNav extends StatelessWidget {
  final List<BottomNavEntry> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusSheet),
        ),
        boxShadow: AppShadows.elevatedUp,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s,
            vertical: AppSizes.s,
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: BottomNavItem(
                    icon: items[i].icon,
                    label: items[i].label,
                    isActive: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One tab: icon + label, primary with a small underline when active, grey
/// otherwise.
class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textHint;
    return Semantics(
      selected: isActive,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: AppSizes.iconL),
              const SizedBox(height: AppSizes.xxs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isActive
                    ? AppTextStyles.navLabelActive
                    : AppTextStyles.navLabel,
              ),
              const SizedBox(height: AppSizes.xs),
              AnimatedContainer(
                duration: kThemeAnimationDuration,
                width: isActive ? AppSizes.navIndicatorWidth : 0,
                height: AppSizes.navIndicatorHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.xxs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
