import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/constants/app_strings.dart';
import 'stat_card.dart';

/// Total / Completed / Pending [StatCard]s in three equal columns. Shared by
/// Home (overlapping the header) and Profile.
class TaskStatsRow extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;
  final VoidCallback? onTotalTap;
  final VoidCallback? onCompletedTap;
  final VoidCallback? onPendingTap;

  const TaskStatsRow({
    super.key,
    required this.total,
    required this.completed,
    required this.pending,
    this.onTotalTap,
    this.onCompletedTap,
    this.onPendingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: AppStrings.total,
            count: total,
            icon: AppIcons.total,
            color: AppColors.statTotal,
            tint: AppColors.statTotalTint,
            tintGradient: AppColors.totalTintGradient,
            iconBoxColor: AppColors.statTotalIconBox,
            labelColor: AppColors.statText,
            onTap: onTotalTap,
          ),
        ),
        const SizedBox(width: AppSizes.m),
        Expanded(
          child: StatCard(
            title: AppStrings.completed,
            count: completed,
            icon: AppIcons.completed,
            color: AppColors.statCompleted,
            tint: AppColors.statCompletedTint,
            iconBoxColor: AppColors.statCompletedIconBox,
            onTap: onCompletedTap,
          ),
        ),
        const SizedBox(width: AppSizes.m),
        Expanded(
          child: StatCard(
            title: AppStrings.pending,
            count: pending,
            icon: AppIcons.pending,
            color: AppColors.statPending,
            tint: AppColors.statPendingTint,
            tintGradient: AppColors.pendingTintGradient,
            iconBoxColor: AppColors.statPendingIconBox,
            labelColor: AppColors.statText,
            onTap: onPendingTap,
          ),
        ),
      ],
    );
  }
}
