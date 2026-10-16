import 'package:get/get.dart';

import '../../modules/calendar/controllers/calendar_controller.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/profile/controllers/profile_controller.dart';
import '../../modules/shell/controllers/main_shell_controller.dart';

/// Controllers for the MAIN shell and its three tabs. Calendar and Profile
/// read the task list from [HomeController], so Firestore is queried once.
class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(MainShellController.new);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find(), Get.find(), Get.find(), Get.find()),
    );
    Get.lazyPut<CalendarController>(() => CalendarController(Get.find()));
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find(), Get.find(), Get.find()),
    );
  }
}
