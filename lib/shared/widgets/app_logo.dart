import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_images.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';

/// App logo from [AppImages.logo], shown directly (no white tile) with a soft
/// purple shadow. Falls back to [AppIcons.logo] if the image is missing.
///
/// The image file has white corners around its cream rounded square, so it
/// is clipped to a rounded square and zoomed slightly
/// ([AppSizes.logoImageScale]) until no white edge remains.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showShadow;

  const AppLogo({
    super.key,
    this.size = AppSizes.authLogo,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * AppSizes.logoRadiusFactor);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: showShadow ? AppShadows.elevated : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox.square(
          dimension: size,
          child: Transform.scale(
            scale: AppSizes.logoImageScale,
            child: Image.asset(
              AppImages.logo,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Icon(
                  AppIcons.logo,
                  color: AppColors.white,
                  size: size * 0.55,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
