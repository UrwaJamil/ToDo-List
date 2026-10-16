import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

/// Consistent success / error snackbars, called from controllers.
class AppSnackbar {
  AppSnackbar._();

  // Dark backgrounds so the white text stays readable.
  static void success(String message) => _show(
    AppStrings.success,
    message,
    AppColors.snackbarSuccess,
    AppIcons.success,
  );

  static void error(String message) =>
      _show(AppStrings.error, message, AppColors.snackbarError, AppIcons.error);

  static void _show(String title, String message, Color color, IconData icon) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      titleText: Text(
        title,
        style: AppTextStyles.cardTitle.copyWith(color: AppColors.white),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.body.copyWith(color: AppColors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: AppColors.white,
      icon: Icon(icon, color: AppColors.white),
      margin: const EdgeInsets.all(AppSizes.l),
      borderRadius: AppSizes.radiusM,
      duration: const Duration(seconds: 3),
    );
  }
}
