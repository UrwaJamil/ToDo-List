import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/app_bottom_nav.dart';
import '../../calendar/views/calendar_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_shell_controller.dart';

/// Hosts the Home, Calendar and Profile tabs. IndexedStack keeps all three
/// alive, so each keeps its scroll position and state.
class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  static const List<Widget> _pages = [
    HomeView(),
    CalendarView(),
    ProfileView(),
  ];

  static final List<BottomNavEntry> _navItems = [
    for (final tab in ShellTab.values)
      BottomNavEntry(icon: tab.icon, label: tab.label),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.canPop,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) controller.onBackFromOtherTab();
        },
        child: Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: _pages,
          ),
          bottomNavigationBar: AppBottomNav(
            items: _navItems,
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          ),
        ),
      ),
    );
  }
}
