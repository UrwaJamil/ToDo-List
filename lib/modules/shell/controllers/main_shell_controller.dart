import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_strings.dart';

/// The three bottom-navigation tabs, in display order.
enum ShellTab {
  home(AppIcons.navHome, AppStrings.navHome),
  calendar(AppIcons.navCalendar, AppStrings.navCalendar),
  profile(AppIcons.navProfile, AppStrings.navProfile);

  const ShellTab(this.icon, this.label);

  final IconData icon;
  final String label;
}

/// Which bottom-navigation tab is visible. The pages themselves stay alive
/// in an IndexedStack, so switching tabs keeps scroll position and state.
class MainShellController extends GetxController {
  final RxInt currentIndex = ShellTab.home.index.obs;

  ShellTab get currentTab => ShellTab.values[currentIndex.value];

  void changeTab(int index) {
    if (index >= 0 && index < ShellTab.values.length) {
      currentIndex.value = index;
    }
  }

  void openTab(ShellTab tab) => changeTab(tab.index);

  /// Android back: return to Home first, and only leave the app from Home.
  bool get canPop => currentTab == ShellTab.home;

  void onBackFromOtherTab() => openTab(ShellTab.home);
}
