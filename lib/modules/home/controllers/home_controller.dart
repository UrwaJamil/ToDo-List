import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../app/utils/date_formatter.dart';
import '../../../app/utils/display_helper.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/task_service.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../auth/controllers/auth_controller.dart';

enum TaskFilter {
  all(AppStrings.filterAll),
  pending(AppStrings.pending),
  completed(AppStrings.completed);

  const TaskFilter(this.label);
  final String label;
}

enum TaskSort {
  priority(AppStrings.sortPriority),
  dueDate(AppStrings.sortDueDate);

  const TaskSort(this.label);
  final String label;
}

/// Owns the live task list plus search / filter / sort state for Home.
/// Task actions (toggle, delete, navigation) are reused by the details screen.
class HomeController extends GetxController {
  HomeController(
    this._taskService,
    this._authService,
    this._authController,
    this._notificationService,
  );

  final TaskService _taskService;
  final AuthService _authService;
  final AuthController _authController;
  final NotificationService _notificationService;

  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<TaskFilter> filter = TaskFilter.all.obs;
  final Rx<TaskSort> sort = TaskSort.priority.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final searchController = TextEditingController();

  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  /// Reminders are rebuilt once per Home session, from the first snapshot.
  bool _remindersSynced = false;

  /// Task from a tapped reminder that launched the app (passed by Splash).
  String? _launchTaskId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) _launchTaskId = args;
    _listenToTasks();
  }

  @override
  void onReady() {
    super.onReady();
    final taskId = _launchTaskId;
    _launchTaskId = null;
    if (taskId != null) Get.toNamed(Routes.TASK_DETAILS, arguments: taskId);
  }

  /// Display name of the logged-in user, falling back to the email prefix.
  String get userName {
    final user = _authService.currentUser;
    final name = user?.displayName?.trim() ?? '';
    if (name.isNotEmpty) return name;
    final emailPrefix = user?.email?.split('@').first ?? '';
    return emailPrefix.isNotEmpty ? emailPrefix : AppStrings.guestName;
  }

  /// "Good morning / afternoon / evening" for the current time.
  String get greetingText => DisplayHelper.timeGreeting(DateTime.now());

  /// Today's date for the header, e.g. "Friday, 16 Oct".
  String get todayLabel => DateFormatter.weekdayDayMonth(DateTime.now());

  /// Logout (with confirmation) is owned by [AuthController].
  Future<void> logout() => _authController.logout();

  // ------------------------------------------------------------ live data

  void _listenToTasks() {
    _tasksSubscription?.cancel();
    isLoading.value = true;
    errorMessage.value = '';
    try {
      _tasksSubscription = _taskService.streamTasks().listen(
        (tasks) {
          allTasks.assignAll(tasks);
          errorMessage.value = '';
          isLoading.value = false;
          _syncRemindersOnce(tasks);
        },
        onError: (Object _) {
          errorMessage.value = AppStrings.errorLoadTasks;
          isLoading.value = false;
        },
      );
    } catch (_) {
      errorMessage.value = AppStrings.errorLoadTasks;
      isLoading.value = false;
    }
  }

  void retry() => _listenToTasks();

  /// After login or app start, schedule reminders for every task, including
  /// ones created on another device.
  void _syncRemindersOnce(List<TaskModel> tasks) {
    if (_remindersSynced) return;
    _remindersSynced = true;
    unawaited(_notificationService.syncReminders(tasks));
  }

  // --------------------------------------------------------- computed values

  int get totalCount => allTasks.length;

  int get completedCount => allTasks.where((t) => t.isCompleted).length;

  int get pendingCount => totalCount - completedCount;

  bool get hasNoTasks => allTasks.isEmpty;

  /// Search + filter + sort applied to [allTasks].
  List<TaskModel> get filteredTasks {
    final query = searchQuery.value.toLowerCase();

    final result = allTasks.where((task) {
      final matchesSearch =
          query.isEmpty || task.title.toLowerCase().contains(query);
      final matchesFilter = switch (filter.value) {
        TaskFilter.all => true,
        TaskFilter.pending => !task.isCompleted,
        TaskFilter.completed => task.isCompleted,
      };
      return matchesSearch && matchesFilter;
    }).toList();

    result.sort((a, b) {
      final byPriority = b.priority.weight.compareTo(a.priority.weight);
      final byDueDate = a.dueDate.compareTo(b.dueDate);
      if (sort.value == TaskSort.priority) {
        return byPriority != 0 ? byPriority : byDueDate;
      }
      return byDueDate != 0 ? byDueDate : byPriority;
    });
    return result;
  }

  TaskModel? findTaskById(String id) =>
      allTasks.firstWhereOrNull((task) => task.id == id);

  // ------------------------------------------------------- search/filter/sort

  void onSearchChanged(String value) => searchQuery.value = value.trim();

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void changeFilter(TaskFilter value) => filter.value = value;

  void changeSort(TaskSort? value) {
    if (value != null) sort.value = value;
  }

  // ------------------------------------------------------------ task actions

  Future<void> toggleComplete(TaskModel task) async {
    final newValue = !task.isCompleted;
    try {
      await _taskService.setCompleted(task.id, newValue);
      if (newValue) {
        await _notificationService.cancelTaskReminder(task.id);
      } else {
        await _notificationService.scheduleTaskReminder(
          task.copyWith(isCompleted: false),
        );
      }
      AppSnackbar.success(
        newValue
            ? AppStrings.taskMarkedCompleted
            : AppStrings.taskMarkedPending,
      );
    } catch (_) {
      AppSnackbar.error(AppStrings.errorUpdateTask);
    }
  }

  /// Asks for confirmation, then deletes. [onDeleted] runs before the success
  /// snackbar (e.g. to close the details page). Returns true when deleted.
  Future<bool> deleteTask(TaskModel task, {VoidCallback? onDeleted}) async {
    final confirmed = await ConfirmationDialog.show(
      title: AppStrings.deleteTaskTitle,
      message: AppStrings.deleteTaskMessage(task.title),
      confirmText: AppStrings.delete,
      confirmColor: AppColors.errorDark,
    );
    if (!confirmed) return false;

    try {
      await _taskService.deleteTask(task.id);
      await _notificationService.cancelTaskReminder(task.id);
      onDeleted?.call();
      AppSnackbar.success(AppStrings.taskDeleted);
      return true;
    } catch (_) {
      AppSnackbar.error(AppStrings.errorDeleteTask);
      return false;
    }
  }

  // -------------------------------------------------------------- navigation

  void openAddTask() => Get.toNamed(Routes.ADD_TASK);

  void openEditTask(TaskModel task) =>
      Get.toNamed(Routes.EDIT_TASK, arguments: task);

  void openTaskDetails(TaskModel task) =>
      Get.toNamed(Routes.TASK_DETAILS, arguments: task);

  @override
  void onClose() {
    _tasksSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
