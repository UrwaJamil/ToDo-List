import 'package:flutter/material.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_icons.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/home_controller.dart';

/// Compact sort button; opens a menu with a check mark on the active option.
class SortMenuButton extends StatelessWidget {
  final TaskSort selected;
  final ValueChanged<TaskSort> onSelected;
  final double size;

  const SortMenuButton({
    super.key,
    required this.selected,
    required this.onSelected,
    this.size = AppSizes.searchHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Matches the search bar next to it: white, same height, fully rounded
    // and the same soft purple shadow.
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.searchRadius)),
        boxShadow: AppShadows.soft,
      ),
      child: _buildMenu(),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<TaskSort>(
      tooltip: AppStrings.sortTasks,
      initialValue: selected,
      onSelected: onSelected,
      icon: const Icon(AppIcons.sort),
      // Transparent so the white container (and its shadow) shows through;
      // the same rounded shape keeps the ink ripple inside it.
      style: IconButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.transparent,
        fixedSize: Size.square(size),
        minimumSize: Size.square(size),
        padding: EdgeInsets.zero,
        shape: const StadiumBorder(),
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (_) => [
        for (final sort in TaskSort.values)
          PopupMenuItem<TaskSort>(
            value: sort,
            child: Row(
              children: [
                Icon(
                  AppIcons.check,
                  size: AppSizes.iconM,
                  color: sort == selected
                      ? AppColors.primary
                      : AppColors.transparent,
                ),
                const SizedBox(width: AppSizes.m),
                Flexible(
                  child: Text(
                    AppStrings.sortBy(sort.label),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (sort == selected
                                ? AppTextStyles.bodySemi
                                : AppTextStyles.body)
                            .copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
