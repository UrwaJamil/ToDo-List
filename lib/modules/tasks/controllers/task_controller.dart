import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_strings.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../app/utils/date_formatter.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/task_service.dart';

/// Form state for the shared Add / Edit task screen. If a [TaskModel] is
/// passed through Get.arguments the screen works in edit mode.
class TaskController extends GetxController {
  TaskController(this._taskService, this._notificationService);

  final TaskService _taskService;
  final NotificationService _notificationService;

  static const int maxTitleLength = 100;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();

  final Rxn<DateTime> dueDate = Rxn<DateTime>();
  final Rx<TaskPriority> priority = TaskPriority.medium.obs;
  final RxBool isSaving = false.obs;

  TaskModel? _editingTask;

  bool get isEditMode => _editingTask != null;

  String get pageTitle => isEditMode ? AppStrings.editTask : AppStrings.addTask;

  String get saveButtonLabel =>
      isEditMode ? AppStrings.updateTask : AppStrings.saveTask;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TaskModel) {
      _editingTask = args;
      titleController.text = args.title;
      descriptionController.text = args.description;
      priority.value = args.priority;
      _setDueDate(args.dueDate);
    }
  }

  // ---------------------------------------------------------------- validation

  String? validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) return AppStrings.titleRequired;
    if (title.length > maxTitleLength) return AppStrings.titleTooLong;
    return null;
  }

  String? validateDueDate(String? _) =>
      dueDate.value == null ? AppStrings.dueDateRequired : null;

  // -------------------------------------------------------------------- inputs

  void selectPriority(TaskPriority value) => priority.value = value;

  Future<void> pickDueDate() async {
    final context = Get.context;
    if (context == null) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = dueDate.value;
    // In edit mode an already-past due date must stay selectable.
    final firstDate = current != null && current.isBefore(today)
        ? current
        : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? today,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) _setDueDate(picked);
  }

  void _setDueDate(DateTime value) {
    dueDate.value = value;
    dueDateController.text = DateFormatter.date(value);
  }

  // ------------------------------------------------------------------- saving

  Future<void> saveTask() async {
    if (isSaving.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isSaving.value = true;
    try {
      final editing = _editingTask;
      if (editing == null) {
        final now = DateTime.now();
        final created = await _taskService.createTask(
          TaskModel(
            id: '',
            userId: '',
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            dueDate: dueDate.value!,
            priority: priority.value,
            isCompleted: false,
            createdAt: now,
            updatedAt: now,
          ),
        );
        await _notificationService.scheduleTaskReminder(created);
      } else {
        final updated = editing.copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          dueDate: dueDate.value,
          priority: priority.value,
        );
        await _taskService.updateTask(updated);
        // The reminder shows the title and depends on the due date.
        if (updated.title != editing.title ||
            updated.dueDate != editing.dueDate) {
          await _notificationService.cancelTaskReminder(editing.id);
          await _notificationService.scheduleTaskReminder(updated);
        }
      }
      final message = isEditMode
          ? AppStrings.taskUpdated
          : AppStrings.taskAdded;
      Get.back(closeOverlays: true);
      AppSnackbar.success(message);
    } catch (_) {
      AppSnackbar.error(AppStrings.errorSaveTask);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.onClose();
  }
}
