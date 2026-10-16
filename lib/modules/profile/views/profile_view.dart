import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/background_waves.dart';
import '../../../shared/widgets/curved_header.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/header_card_layout.dart';
import '../../../shared/widgets/task_stats_row.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

/// Profile tab: avatar, name, email, task stats and logout.
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundWaves(),
          HeaderCardLayout(
            header: CurvedHeader(
              showDecoration: true,
              decorationAtTop: true,
              padding: const EdgeInsets.fromLTRB(
                AppSizes.gutter,
                AppSizes.xxl,
                AppSizes.gutter,
                AppSizes.waveDepth + AppSizes.cardOverlap + AppSizes.l,
              ),
              child: Column(
                children: [
                  UserAvatar(
                    name: controller.userName,
                    size: AppSizes.avatarLarge,
                  ),
                  const SizedBox(height: AppSizes.l),
                  Text(
                    controller.userName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headline.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    controller.email,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.secondary.copyWith(
                      color: AppColors.textOnPrimaryMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Stats overlap the curve, the same as on Home.
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => TaskStatsRow(
                      total: controller.totalCount,
                      completed: controller.completedCount,
                      pending: controller.pendingCount,
                      onTotalTap: () => controller.showTasks(TaskFilter.all),
                      onCompletedTap: () =>
                          controller.showTasks(TaskFilter.completed),
                      onPendingTap: () =>
                          controller.showTasks(TaskFilter.pending),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxl),
                  CustomButton(
                    label: AppStrings.logout,
                    icon: AppIcons.logout,
                    color: AppColors.errorDark,
                    isOutlined: true,
                    onPressed: controller.logout,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
