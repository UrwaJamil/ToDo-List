import 'package:flutter/material.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_icons.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/soft_icon_button.dart';

/// Month grid with previous/next buttons. Pure UI: the controller supplies
/// the weeks, the selected day and which days (of the shown month) have
/// tasks, as plain values read inside the caller's Obx.
class MonthCalendar extends StatelessWidget {
  final String monthLabel;
  final List<String> weekdayLabels;
  final List<List<DateTime?>> weeks;
  final DateTime selectedDay;

  /// Day-of-month numbers (of the shown month) with any / pending tasks.
  final Set<int> daysWithTasks;
  final Set<int> daysWithPendingTasks;
  final bool Function(DateTime day) isToday;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthCalendar({
    super.key,
    required this.monthLabel,
    required this.weekdayLabels,
    required this.weeks,
    required this.selectedDay,
    required this.daysWithTasks,
    required this.daysWithPendingTasks,
    required this.isToday,
    required this.onDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SoftIconButton(
              icon: AppIcons.chevronLeft,
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              tooltip: AppStrings.previousMonth,
              onPressed: onPreviousMonth,
            ),
            Expanded(
              child: Text(
                monthLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle,
              ),
            ),
            SoftIconButton(
              icon: AppIcons.chevronRight,
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              tooltip: AppStrings.nextMonth,
              onPressed: onNextMonth,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.l),
        Row(
          children: [
            for (final label in weekdayLabels)
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.s),
        for (final week in weeks)
          Row(
            children: [
              for (final day in week)
                Expanded(
                  child: day == null
                      ? const SizedBox(height: AppSizes.calendarDay)
                      : _DayCell(
                          day: day,
                          isSelected: DateUtils.isSameDay(day, selectedDay),
                          isToday: isToday(day),
                          hasTasks: daysWithTasks.contains(day.day),
                          hasPendingTasks: daysWithPendingTasks.contains(
                            day.day,
                          ),
                          onTap: () => onDaySelected(day),
                        ),
                ),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool hasTasks;
  final bool hasPendingTasks;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasTasks,
    required this.hasPendingTasks,
    required this.onTap,
  });

  /// Pending blue if anything is still open that day, completed green if
  /// everything is done; white on the selected (purple) day.
  Color get _dotColor {
    if (!hasTasks) return AppColors.transparent;
    if (isSelected) return AppColors.white;
    return hasPendingTasks ? AppColors.pending : AppColors.completed;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected
        ? AppColors.white
        : isToday
        ? AppColors.primary
        : AppColors.textPrimary;

    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: AppSizes.calendarDay,
          child: Center(
            child: AnimatedContainer(
              duration: kThemeAnimationDuration,
              width: AppSizes.calendarDay - AppSizes.xs,
              height: AppSizes.calendarDay - AppSizes.xs,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: AppColors.lavender)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style:
                        (isSelected || isToday
                                ? AppTextStyles.bodySemi
                                : AppTextStyles.body)
                            .copyWith(color: textColor, height: 1.1),
                  ),
                  // Dot for days with tasks; an empty box keeps rows aligned.
                  Container(
                    width: AppSizes.statusDot,
                    height: AppSizes.statusDot,
                    margin: const EdgeInsets.only(top: AppSizes.xxs),
                    decoration: BoxDecoration(
                      color: _dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
