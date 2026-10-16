import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/task_service.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/notifications/controllers/notification_controller.dart';

/// App-wide dependencies that live for the whole app lifetime. main() runs
/// this before runApp so NotificationService can be initialized first.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services are created immediately and never disposed.
    final authService = Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<TaskService>(TaskService(authService), permanent: true);
    final notificationService = Get.put<NotificationService>(
      NotificationService(),
      permanent: true,
    );

    // Auth state spans Login, Sign-Up and Home (logout), so this one
    // controller is app-wide instead of being tied to a single route.
    Get.put<AuthController>(
      AuthController(authService, notificationService),
      permanent: true,
    );

    // A reminder can be tapped on any screen, so this is app-wide too.
    Get.put<NotificationController>(
      NotificationController(notificationService, authService),
      permanent: true,
    );
  }
}
