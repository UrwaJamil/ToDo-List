import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../routes/app_routes.dart';

/// Route guard for protected pages: unauthenticated users go to LOGIN.
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = Get.find<AuthService>().currentUser != null;
    return isLoggedIn ? null : const RouteSettings(name: Routes.LOGIN);
  }
}

/// Inverse guard for LOGIN / SIGNUP: a logged-in user goes straight to MAIN.
class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = Get.find<AuthService>().currentUser != null;
    return isLoggedIn ? const RouteSettings(name: Routes.MAIN) : null;
  }
}
