import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/utils/date_formatter.dart';
import '../../../data/models/task_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/header_card_layout.dart';
import '../../../shared/widgets/info_badge.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/priority_chip.dart';
import '../controllers/task_details_controller.dart';

class TaskDetailsView extends GetView<TaskDetailsController> {
  const TaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final task = controller.task.value;
        return Column(
          children: [
            Expanded(
              child: HeaderCardLayout(
                header: PageHeader(
                  title: AppStrings.taskDetails,
                  onBack: Get.back,
                ),
                body: task == null
                    ? const AppCard(child: LoadingWidget())
                    : _DetailsCard(
                        task: task,
                        reminderText: controller.reminderText,
                        hasReminder: controller.hasReminder,
                      ),
              ),
            ),
            if (task != null) _buildActions(task),
          ],
        );
      }),
    );
  }

  Widget _buildActions(TaskModel task) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.gutter,
          0,
          AppSizes.gutter,
          AppSizes.xl,
        ),
        child: Column(
          children: [
            CustomButton(
              label: task.isCompleted
                  ? AppStrings.markPending
                  : AppStrings.markCompleted,
              icon: task.isCompleted ? AppIcons.markPending : AppIcons.markDone,
              color: task.isCompleted
                  ? AppColors.pendingText
                  : AppColors.completedText,
              onPressed: controller.toggleComplete,
            ),
            const SizedBox(height: AppSizes.m),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: AppStrings.edit,
                    icon: AppIcons.edit,
                    isOutlined: true,
                    onPressed: controller.editTask,
                  ),
                ),
                const SizedBox(width: AppSizes.m),
                Expanded(
                  child: CustomButton(
                    label: AppStrings.delete,
                    icon: AppIcons.delete,
                    color: AppColors.errorDark,
                    isOutlined: true,
                    onPressed: controller.deleteTask,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final TaskModel task;
  final String reminderText;
  final bool hasReminder;

  const _DetailsCard({
    required this.task,
    required this.reminderText,
    required this.hasReminder,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: AppTextStyles.headline.copyWith(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: AppSizes.m),
          Wrap(
            spacing: AppSizes.s,
            runSpacing: AppSizes.s,
            children: [
              InfoBadge(
                label: task.isCompleted
                    ? AppStrings.completed
                    : AppStrings.pending,
                color: task.isCompleted
                    ? AppColors.completed
                    : AppColors.pending,
                textColor: task.isCompleted
                    ? AppColors.completedText
                    : AppColors.pendingText,
                tintColor: task.isCompleted ? null : AppColors.pendingTint,
                icon: task.isCompleted ? AppIcons.completed : AppIcons.pending,
              ),
              PriorityChip(priority: task.priority),
              if (task.isOverdue) const InfoBadge.overdue(),
            ],
          ),
          const Divider(height: AppSizes.xxxl + AppSizes.xs),
          _DetailRow(
            icon: AppIcons.description,
            label: AppStrings.descriptionLabel,
            value: task.description.isEmpty
                ? AppStrings.noDescription
                : task.description,
          ),
          _DetailRow(
            icon: AppIcons.calendar,
            label: AppStrings.dueDateLabel,
            value: DateFormatter.date(task.dueDate),
            valueColor: task.isOverdue ? AppColors.overdueText : null,
          ),
          _ReminderLine(text: reminderText, isActive: hasReminder),
          _DetailRow(
            icon: AppIcons.time,
            label: AppStrings.createdAt,
            value: DateFormatter.dateTime(task.createdAt),
          ),
          _DetailRow(
            icon: AppIcons.update,
            label: AppStrings.updatedAt,
            value: DateFormatter.dateTime(task.updatedAt),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

/// Small line under the due date, e.g. "Reminder: Thu, 15 Oct, 9:00 AM".
class _ReminderLine extends StatelessWidget {
  final String text;
  final bool isActive;

  const _ReminderLine({required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.purpleText : AppColors.textHint;
    return Padding(
      // Indented to line up with the text of the rows above.
      padding: const EdgeInsets.only(
        left: AppSizes.statIconBox + AppSizes.m,
        bottom: AppSizes.l,
      ),
      child: Row(
        children: [
          Icon(
            isActive ? AppIcons.reminder : AppIcons.noReminder,
            size: AppSizes.iconS,
            color: color,
          ),
          const SizedBox(width: AppSizes.s - AppSizes.xxs),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.secondary.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.statIconBox,
            height: AppSizes.statIconBox,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Icon(icon, size: AppSizes.iconM, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.secondary),
                const SizedBox(height: AppSizes.xxs),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
