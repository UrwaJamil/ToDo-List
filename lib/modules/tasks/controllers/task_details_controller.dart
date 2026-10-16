import 'package:get/get.dart';

import '../../../app/constants/app_strings.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../app/utils/date_formatter.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/notification_service.dart';
import '../../home/controllers/home_controller.dart';

/// Keeps the shown task in sync with the live Firestore list and delegates
/// task actions to [HomeController] so that logic is not duplicated.
///
/// Opened with a [TaskModel] (from a list) or a task ID (from a tapped
/// reminder, where the task is looked up once the list has loaded).
class TaskDetailsController extends GetxController {
  TaskDetailsController(this._homeController);

  final HomeController _homeController;

  final Rxn<TaskModel> task = Rxn<TaskModel>();

  String? _taskId;
  final List<Worker> _workers = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TaskModel) {
      task.value = args;
      _taskId = args.id;
    } else if (args is String && args.isNotEmpty) {
      _taskId = args;
      task.value = _homeController.findTaskById(args);
    }

    // Refresh after edits / toggles made anywhere in the app.
    _workers.add(
      ever<List<TaskModel>>(_homeController.allTasks, (_) {
        final id = _taskId;
        if (id == null) return;
        final updated = _homeController.findTaskById(id);
        if (updated != null) task.value = updated;
      }),
    );
  }

  @override
  void onReady() {
    super.onReady();
    // Opened without a task (e.g. a deep link): go back to Home.
    if (_taskId == null) {
      Get.offAllNamed(Routes.MAIN);
      return;
    }
    if (task.value != null) return;
    // Opened from a reminder before the task list arrived: wait for it.
    if (_homeController.isLoading.value) {
      _workers.add(
        once<bool>(_homeController.isLoading, (_) => _closeIfMissing()),
      );
    } else {
      _closeIfMissing();
    }
  }

  /// Switches to another task, e.g. a reminder tapped while this is open.
  void showTask(String taskId) {
    _taskId = taskId;
    final found = _homeController.findTaskById(taskId);
    if (found != null) {
      task.value = found;
    } else if (!_homeController.isLoading.value) {
      AppSnackbar.error(AppStrings.taskNotFound);
    }
  }

  /// The reminder pointed at a task that was deleted.
  void _closeIfMissing() {
    if (task.value != null) return;
    Get.back(closeOverlays: true);
    AppSnackbar.error(AppStrings.taskNotFound);
  }

  // --------------------------------------------------------------- reminder

  /// e.g. "Reminder: Thu, 15 Oct, 9:00 AM", or "No reminder" when the task
  /// is completed or no longer due in the future.
  String get reminderText {
    final current = task.value;
    if (current == null) return AppStrings.noReminder;
    final now = DateTime.now();
    final at = NotificationService.reminderTimeFor(
      current,
      now,
      allowImmediate: false,
    );
    if (at != null) {
      return '${AppStrings.reminderLabel}: ${DateFormatter.reminder(at)}';
    }
    // 9:00 AM the day before already passed, but the task is still upcoming.
    if (NotificationService.reminderTimeFor(current, now) != null) {
      return '${AppStrings.reminderLabel}: ${AppStrings.reminderSentNow}';
    }
    return AppStrings.noReminder;
  }

  bool get hasReminder =>
      task.value != null &&
      NotificationService.reminderTimeFor(task.value!, DateTime.now()) != null;

  // ---------------------------------------------------------------- actions

  void toggleComplete() {
    final current = task.value;
    if (current != null) _homeController.toggleComplete(current);
  }

  void editTask() {
    final current = task.value;
    if (current != null) _homeController.openEditTask(current);
  }

  Future<void> deleteTask() async {
    final current = task.value;
    if (current == null) return;
    await _homeController.deleteTask(
      current,
      onDeleted: () => Get.back(closeOverlays: true),
    );
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }
}
