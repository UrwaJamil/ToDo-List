import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../shell/controllers/main_shell_controller.dart';

/// User info and task stats for the Profile tab. Counts come from
/// [HomeController], and logout reuses its confirmation flow.
class ProfileController extends GetxController {
  ProfileController(this._homeController, this._authService, this._shell);

  final HomeController _homeController;
  final AuthService _authService;
  final MainShellController _shell;

  String get userName => _homeController.userName;

  String get email => _authService.currentUser?.email ?? '';

  int get totalCount => _homeController.totalCount;

  int get completedCount => _homeController.completedCount;

  int get pendingCount => _homeController.pendingCount;

  /// Tapping a stat card shows that list on the Home tab.
  void showTasks(TaskFilter filter) {
    _homeController.changeFilter(filter);
    _shell.openTab(ShellTab.home);
  }

  Future<void> logout() => _homeController.logout();
}
