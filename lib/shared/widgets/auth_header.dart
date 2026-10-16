import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/constants/app_strings.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_logo.dart';
import 'curved_header.dart';

/// Curved purple header for the auth screens: logo, app name and
/// tagline. [overlap] is the space kept free at the bottom for the form card
/// that slides over it.
class AuthHeader extends StatelessWidget {
  final double overlap;

  const AuthHeader({super.key, this.overlap = AppSizes.cardOverlap});

  @override
  Widget build(BuildContext context) {
    return CurvedHeader(
      showDecoration: true,
      decorationAtTop: true,
      padding: EdgeInsets.fromLTRB(
        AppSizes.xxl,
        AppSizes.xxl,
        AppSizes.xxl,
        AppSizes.waveDepth + overlap + AppSizes.l,
      ),
      // Decorations are Positioned layers inside CurvedHeader and take no
      // part in this layout; equal side padding keeps everything centred.
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shown directly on the gradient: clipped, with its own shadow.
            const AppLogo(size: AppSizes.authLogo),
            const SizedBox(height: AppSizes.l),
            Text(
              AppStrings.appName,
              textAlign: TextAlign.center,
              style: AppTextStyles.headline.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSizes.s),
            Text(
              AppStrings.appTagline,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textOnPrimaryMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
