import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/background_waves.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/header_card_layout.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/task_card.dart';
import '../controllers/calendar_controller.dart';
import 'widgets/month_calendar.dart';

/// Calendar tab: a month grid (dots on days with tasks) and the tasks due on
/// the selected day.
class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundWaves(),
          HeaderCardLayout(
            header: const PageHeader(
              title: AppStrings.calendarTitle,
              subtitle: AppStrings.calendarSubtitle,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  padding: const EdgeInsets.all(AppSizes.l),
                  child: Obx(
                    () => MonthCalendar(
                      monthLabel: controller.monthLabel,
                      weekdayLabels: controller.weekdayLabels,
                      weeks: controller.weeks,
                      // Read here (inside Obx) so changes rebuild the grid.
                      selectedDay: controller.selectedDay.value,
                      daysWithTasks: controller.daysWithTasks,
                      daysWithPendingTasks: controller.daysWithPendingTasks,
                      isToday: controller.isToday,
                      onDaySelected: controller.selectDay,
                      onPreviousMonth: controller.previousMonth,
                      onNextMonth: controller.nextMonth,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                Obx(_buildDayTasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTasks() {
    if (controller.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppSizes.xxl),
        child: LoadingWidget(),
      );
    }

    final tasks = controller.selectedDayTasks;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(controller.selectedDayTitle, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSizes.m),
          if (tasks.isEmpty)
            const EmptyStateWidget(
              icon: AppIcons.navCalendar,
              title: AppStrings.noTasksOnDayTitle,
              message: AppStrings.noTasksOnDayMessage,
            )
          else
            for (final task in tasks) ...[
              TaskCard(
                key: ValueKey(task.id),
                task: task,
                onTap: () => controller.openTaskDetails(task),
                onToggle: () => controller.toggleComplete(task),
                onEdit: () => controller.openEditTask(task),
                onDelete: () => controller.deleteTask(task),
              ),
              const SizedBox(height: AppSizes.cardSpacing),
            ],
        ],
      ),
    );
  }
}
