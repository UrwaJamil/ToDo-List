import 'dart:async';

import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/notification_service.dart';
import '../../tasks/controllers/task_details_controller.dart';

/// App-wide: turns a tapped task reminder into navigation. Lives for the
/// whole app (registered in AppBinding) because a reminder can be tapped
/// while any screen is open.
class NotificationController extends GetxController {
  NotificationController(this._notificationService, this._authService);

  final NotificationService _notificationService;
  final AuthService _authService;

  StreamSubscription<String>? _tapSubscription;

  /// A tap that arrived while the splash screen was still deciding the route.
  String? _pendingTaskId;

  @override
  void onInit() {
    super.onInit();
    _tapSubscription = _notificationService.onTaskTapped.listen(openTask);
  }

  /// Task to open once the app has routed past the splash screen: either the
  /// reminder that launched the app, or one tapped during the splash.
  String? takePendingTaskId() {
    final id = _notificationService.takeLaunchTaskId() ?? _pendingTaskId;
    _pendingTaskId = null;
    return id;
  }

  /// Opens Task Details for [taskId], or Login when nobody is logged in.
  void openTask(String taskId) {
    if (_authService.currentUser == null) {
      if (Get.currentRoute != Routes.LOGIN) Get.offAllNamed(Routes.LOGIN);
      return;
    }
    switch (Get.currentRoute) {
      case Routes.SPLASH:
        _pendingTaskId = taskId;
      case Routes.TASK_DETAILS:
        // Reuse the open details page; a second one would share its
        // controller (GetX keeps one instance per type).
        Get.find<TaskDetailsController>().showTask(taskId);
      default:
        Get.toNamed(Routes.TASK_DETAILS, arguments: taskId);
    }
  }

  @override
  void onClose() {
    _tapSubscription?.cancel();
    super.onClose();
  }
}
