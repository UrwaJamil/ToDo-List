import 'package:flutter/material.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_icons.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/soft_icon_button.dart';
import '../../../../shared/widgets/user_avatar.dart';

/// Content of the Home purple header: avatar, greeting, name and actions,
/// then the "My Tasks" title and today's date.
class HomeHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String dateLabel;
  final VoidCallback onLogout;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.dateLabel,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserAvatar(name: userName),
            const SizedBox(width: AppSizes.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.secondary.copyWith(
                      color: AppColors.textOnPrimaryMuted,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxs),
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headerName.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.m),
            SoftIconButton.onHeader(
              icon: AppIcons.logout,
              tooltip: AppStrings.logout,
              onPressed: onLogout,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xxl),
        Text(
          AppStrings.myTasks,
          style: AppTextStyles.screenTitle.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          dateLabel,
          style: AppTextStyles.secondary.copyWith(
            color: AppColors.textOnPrimaryMuted,
          ),
        ),
      ],
    );
  }
}
