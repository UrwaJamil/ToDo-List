import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';

/// Icon button inside a soft rounded square (tinted background, colored icon).
class SoftIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final String? tooltip;
  final double size;

  const SoftIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onPressed,
    this.borderColor,
    this.tooltip,
    this.size = AppSizes.iconButton,
  });

  /// Translucent white square for use on the purple header.
  const SoftIconButton.onHeader({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = AppSizes.iconButton,
  }) : color = AppColors.white,
       backgroundColor = AppColors.translucentWhite,
       borderColor = AppColors.translucentWhiteBorder;

  /// Shared style so other buttons (e.g. a PopupMenuButton) look identical.
  static ButtonStyle styleFor({
    required Color color,
    required Color backgroundColor,
    Color? borderColor,
    double size = AppSizes.iconButton,
  }) {
    return IconButton.styleFrom(
      foregroundColor: color,
      backgroundColor: backgroundColor,
      fixedSize: Size.square(size),
      minimumSize: Size.square(size),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: AppSizes.iconM),
      tooltip: tooltip,
      onPressed: onPressed,
      style: styleFor(
        color: color,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        size: size,
      ),
    );
  }
}
