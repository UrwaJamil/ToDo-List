import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';
import '../../notifications/controllers/notification_controller.dart';

/// Waits for Firebase to restore the session, then routes to Home or Login.
class SplashController extends GetxController {
  SplashController(this._authService, this._notificationController);

  final AuthService _authService;
  final NotificationController _notificationController;

  static const Duration _minimumSplashTime = Duration(milliseconds: 1200);

  @override
  void onReady() {
    super.onReady();
    _decideRoute();
  }

  Future<void> _decideRoute() async {
    final minimumDelay = Future<void>.delayed(_minimumSplashTime);
    final user = await _authService.authStateChanges.first;
    await minimumDelay;
    // Set when the app was opened by tapping a reminder.
    final taskId = _notificationController.takePendingTaskId();
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      // Home (inside the shell) opens the task's details once it is ready.
      Get.offAllNamed(Routes.MAIN, arguments: taskId);
    }
  }
}
