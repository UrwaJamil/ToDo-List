import 'package:get/get.dart';

import '../../modules/tasks/controllers/task_controller.dart';

/// Used by both ADD_TASK and EDIT_TASK; the controller decides the mode
/// from Get.arguments.
class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController(Get.find(), Get.find()));
  }
}
