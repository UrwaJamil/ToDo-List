import 'package:get/get.dart';

import '../../../app/constants/app_strings.dart';
import '../../../app/utils/date_formatter.dart';
import '../../../data/models/task_model.dart';
import '../../home/controllers/home_controller.dart';

/// Month calendar over [HomeController.allTasks]: no extra Firestore query.
/// Days with tasks get a dot; selecting a day lists the tasks due on it.
class CalendarController extends GetxController {
  CalendarController(this._homeController);

  final HomeController _homeController;

  /// First day of the month on screen.
  final Rx<DateTime> visibleMonth = _monthOf(DateTime.now()).obs;
  final Rx<DateTime> selectedDay = _dayOf(DateTime.now()).obs;

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ---------------------------------------------------------------- grid

  String get monthLabel => DateFormatter.monthYear(visibleMonth.value);

  /// Column headers, Mon … Sun.
  List<String> get weekdayLabels {
    // 1 Jan 2024 was a Monday.
    final monday = DateTime(2024);
    return [
      for (var i = 0; i < DateTime.daysPerWeek; i++)
        DateFormatter.weekdayShort(monday.add(Duration(days: i))),
    ];
  }

  /// The visible month as weeks of 7 cells (Monday first). Cells outside the
  /// month are null.
  List<List<DateTime?>> get weeks {
    final first = visibleMonth.value;
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final leading = first.weekday - DateTime.monday;

    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= daysInMonth; d++)
        DateTime(first.year, first.month, d),
    ];
    while (cells.length % DateTime.daysPerWeek != 0) {
      cells.add(null);
    }
    return [
      for (var i = 0; i < cells.length; i += DateTime.daysPerWeek)
        cells.sublist(i, i + DateTime.daysPerWeek),
    ];
  }

  // These read Rx values, so the view must call them inside its Obx builder
  // (not from a child widget's build) for the grid to update.

  /// Days of the visible month that have at least one task due.
  Set<int> get daysWithTasks => _daysOfVisibleMonth((_) => true);

  /// Days of the visible month with at least one task not completed yet
  /// (their dot uses the pending color, otherwise the completed color).
  Set<int> get daysWithPendingTasks =>
      _daysOfVisibleMonth((task) => !task.isCompleted);

  Set<int> _daysOfVisibleMonth(bool Function(TaskModel task) test) {
    final month = visibleMonth.value;
    return {
      for (final task in _homeController.allTasks)
        if (task.dueDate.year == month.year &&
            task.dueDate.month == month.month &&
            test(task))
          task.dueDate.day,
    };
  }

  bool isToday(DateTime day) => isSameDay(day, DateTime.now());

  // ------------------------------------------------------------- selection

  void selectDay(DateTime day) => selectedDay.value = _dayOf(day);

  void previousMonth() => _shiftMonth(-1);

  void nextMonth() => _shiftMonth(1);

  void _shiftMonth(int delta) {
    final m = visibleMonth.value;
    visibleMonth.value = DateTime(m.year, m.month + delta);
  }

  String get selectedDayTitle =>
      AppStrings.tasksOnDay(DateFormatter.weekdayDayMonth(selectedDay.value));

  /// Tasks due on [selectedDay], pending first, then by priority.
  List<TaskModel> get selectedDayTasks {
    final day = selectedDay.value;
    final tasks = _homeController.allTasks
        .where((task) => isSameDay(task.dueDate, day))
        .toList();
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      return b.priority.weight.compareTo(a.priority.weight);
    });
    return tasks;
  }

  bool get isLoading => _homeController.isLoading.value;

  // ------------------------------------------- task actions (same as Home)

  void openTaskDetails(TaskModel task) => _homeController.openTaskDetails(task);

  void toggleComplete(TaskModel task) => _homeController.toggleComplete(task);

  void openEditTask(TaskModel task) => _homeController.openEditTask(task);

  Future<void> deleteTask(TaskModel task) => _homeController.deleteTask(task);
}
