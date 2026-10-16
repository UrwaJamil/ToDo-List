import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/curved_header.dart';
import '../../../shared/widgets/header_decoration.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: CurvedHeader.overlayStyle,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          child: SafeArea(
            child: Stack(
              children: [
                const Positioned(
                  top: AppSizes.xxl,
                  right: AppSizes.xxl,
                  child: HeaderDecoration(),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: AppSizes.splashLogo),
                      const SizedBox(height: AppSizes.xxl),
                      Text(
                        AppStrings.appName,
                        style: AppTextStyles.display.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.s),
                      Text(
                        AppStrings.appTagline,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textOnPrimaryMuted,
                        ),
                      ),
                      const SizedBox(height: AppSizes.huge),
                      const LoadingWidget(color: AppColors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
