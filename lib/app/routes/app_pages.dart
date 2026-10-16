import 'package:get/get.dart';

import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/signup_view.dart';
import '../../modules/shell/views/main_shell_view.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/tasks/views/add_edit_task_view.dart';
import '../../modules/tasks/views/task_details_view.dart';
import '../bindings/forgot_password_binding.dart';
import '../bindings/main_shell_binding.dart';
import '../bindings/splash_binding.dart';
import '../bindings/task_binding.dart';
import '../bindings/task_details_binding.dart';
import '../middlewares/auth_middleware.dart';
import 'app_routes.dart';

/// Maps every route name to its page, binding and middlewares.
class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    // AuthController is registered app-wide in AppBinding, so Login and
    // Sign-Up need no binding of their own. Forgot Password has its own
    // short-lived controller.
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      middlewares: [GuestMiddleware()],
    ),
    // Home, Calendar and Profile are tabs inside this one protected route.
    GetPage(
      name: Routes.MAIN,
      page: () => const MainShellView(),
      binding: MainShellBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.ADD_TASK,
      page: () => const AddEditTaskView(),
      binding: TaskBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.EDIT_TASK,
      page: () => const AddEditTaskView(),
      binding: TaskBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.TASK_DETAILS,
      page: () => const TaskDetailsView(),
      binding: TaskDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
