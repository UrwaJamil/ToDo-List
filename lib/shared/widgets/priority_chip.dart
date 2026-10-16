import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../data/models/task_model.dart';
import 'info_badge.dart';

/// Priority label colored by priority (High red, Medium orange, Low green).
/// Pass [onTap] to use it as a selectable option in the task form.
class PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final VoidCallback? onTap;

  const PriorityChip({
    super.key,
    required this.priority,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = InfoBadge(
      label: priority.label,
      color: AppColors.priorityColor(priority),
      textColor: AppColors.priorityTextColor(priority),
      icon: AppIcons.flag,
      filled: isSelected,
    );
    if (onTap == null) return badge;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusChip),
      child: Padding(padding: const EdgeInsets.all(AppSizes.xxs), child: badge),
    );
  }
}
