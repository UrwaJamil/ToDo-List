import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/constants/app_strings.dart';
import '../../app/theme/app_text_styles.dart';

/// Reusable yes/no dialog. Use [ConfirmationDialog.show] to await the answer.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final IconData icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    this.cancelText = AppStrings.cancel,
    this.confirmColor = AppColors.primary,
    this.icon = AppIcons.warning,
  });

  /// Returns true only if the user tapped the confirm button.
  static Future<bool> show({
    required String title,
    required String message,
    required String confirmText,
    Color confirmColor = AppColors.primary,
    IconData icon = AppIcons.warning,
  }) async {
    final result = await Get.dialog<bool>(
      ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Navigator.pop (not Get.back) so an open snackbar cannot swallow the tap.
    return AlertDialog(
      icon: Icon(icon, color: confirmColor, size: AppSizes.iconXl),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: AppTextStyles.button.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor,
            textStyle: AppTextStyles.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
