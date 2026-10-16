import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/constants/app_strings.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/date_formatter.dart';
import '../../data/models/task_model.dart';
import 'info_badge.dart';
import 'priority_chip.dart';

/// One task in a list (Home and Calendar). All actions are callbacks so the
/// card stays free of logic.
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusTaskCard);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: AppSizes.statusStrip,
                  color: AppColors.statusColor(task),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.l,
                      AppSizes.m,
                      AppSizes.xs,
                      AppSizes.m,
                    ),
                    child: _TaskInfo(task: task),
                  ),
                ),
                _TaskActions(
                  isCompleted: task.isCompleted,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onToggle: onToggle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Right-hand column: Edit, Delete, then the completion checkbox, each with
/// an [AppSizes.tapTarget] square tap area.
class _TaskActions extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _TaskActions({
    required this.isCompleted,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  static const BoxConstraints _target = BoxConstraints.tightFor(
    width: AppSizes.tapTarget,
    height: AppSizes.tapTarget,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        AppSizes.xs,
        AppSizes.xs,
        AppSizes.xs,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(AppIcons.edit, size: AppSizes.taskActionIcon),
            color: AppColors.primary,
            padding: EdgeInsets.zero,
            constraints: _target,
            tooltip: AppStrings.edit,
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(AppIcons.delete, size: AppSizes.taskActionIcon),
            color: AppColors.error,
            padding: EdgeInsets.zero,
            constraints: _target,
            tooltip: AppStrings.delete,
            onPressed: onDelete,
          ),
          ConstrainedBox(
            constraints: _target,
            child: Checkbox(
              value: isCompleted,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (_) => onToggle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskInfo extends StatelessWidget {
  final TaskModel task;

  const _TaskInfo({required this.task});

  @override
  Widget build(BuildContext context) {
    final done = task.isCompleted;
    final dateColor = task.isOverdue
        ? AppColors.overdueText
        : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          // Completed: muted and clearly struck through.
          style: done
              ? AppTextStyles.cardTitle.copyWith(
                  color: AppColors.completedTaskText,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.completedTaskText,
                  decorationThickness: AppSizes.strikeThickness,
                )
              : AppTextStyles.cardTitle,
        ),
        if (task.description.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xs),
          Text(
            task.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: done
                ? AppTextStyles.bodyMuted.copyWith(
                    color: AppColors.completedTaskText,
                  )
                : AppTextStyles.bodyMuted,
          ),
        ],
        const SizedBox(height: AppSizes.s),
        Wrap(
          spacing: AppSizes.s,
          runSpacing: AppSizes.s - AppSizes.xxs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.calendar,
                  size: AppSizes.iconXs,
                  color: dateColor,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  DateFormatter.date(task.dueDate),
                  style:
                      (task.isOverdue
                              ? AppTextStyles.secondarySemi
                              : AppTextStyles.secondary)
                          .copyWith(color: dateColor),
                ),
              ],
            ),
            PriorityChip(priority: task.priority),
            if (task.isOverdue) const InfoBadge.overdue(),
          ],
        ),
      ],
    );
  }
}
