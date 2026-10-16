import 'package:get/get.dart';

import '../../modules/home/controllers/home_controller.dart';
import '../../modules/tasks/controllers/task_details_controller.dart';

class TaskDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Normally HomeController already exists (details is opened from Home);
    // lazyPut is ignored in that case, so this only matters for deep links.
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find(), Get.find(), Get.find(), Get.find()),
    );
    Get.lazyPut<TaskDetailsController>(() => TaskDetailsController(Get.find()));
  }
}
