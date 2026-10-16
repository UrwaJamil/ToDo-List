import 'package:get/get.dart';

import '../../modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put (not lazyPut): the splash view never reads the controller, but
    // it must exist so its onReady() can decide where to route.
    Get.put<SplashController>(SplashController(Get.find(), Get.find()));
  }
}
