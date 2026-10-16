import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

/// Full-width button with a built-in loading state. Filled (optionally with a
/// glowing [gradient], the primary style) or outlined.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color color;
  final bool isOutlined;

  /// Optional gradient fill (ignored for outlined buttons).
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.color = AppColors.primary,
    this.isOutlined = false,
    this.gradient,
  });

  /// The app's main call-to-action: purple gradient with a soft glow.
  const CustomButton.gradient({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : color = AppColors.primary,
       isOutlined = false,
       gradient = AppColors.primaryGradient;

  @override
  Widget build(BuildContext context) {
    final foreground = isOutlined ? color : AppColors.textOnPrimary;
    final radius = BorderRadius.circular(AppSizes.radiusButton);
    final shape = RoundedRectangleBorder(borderRadius: radius);

    final child = isLoading
        ? SizedBox.square(
            dimension: AppSizes.spinner,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconM),
                const SizedBox(width: AppSizes.s),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.button.copyWith(color: foreground),
                ),
              ),
            ],
          );

    final onTap = isLoading ? null : onPressed;
    final useGradient = gradient != null && !isOutlined;
    // A null onPressed (not loading) means the action is blocked: fade it.
    final isDisabled = onPressed == null && !isLoading;

    final button = SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                backgroundColor: AppColors.surface,
                side: BorderSide(color: color.withValues(alpha: 0.5)),
                shape: shape,
              ),
              child: child,
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: useGradient ? gradient : null,
                borderRadius: radius,
                boxShadow: useGradient && !isDisabled ? AppShadows.glow : null,
              ),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: useGradient ? AppColors.transparent : color,
                  foregroundColor: foreground,
                  disabledBackgroundColor: useGradient
                      ? AppColors.transparent
                      : color.withValues(alpha: 0.6),
                  disabledForegroundColor: foreground,
                  shadowColor: AppColors.transparent,
                  elevation: 0,
                  shape: shape,
                ),
                child: child,
              ),
            ),
    );

    return isDisabled ? Opacity(opacity: 0.5, child: button) : button;
  }
}
