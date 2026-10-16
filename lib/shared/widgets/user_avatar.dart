import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/display_helper.dart';

/// Circle with the user's initials on a lavender gradient.
class UserAvatar extends StatelessWidget {
  final String name;
  final double size;

  const UserAvatar({
    super.key,
    required this.name,
    this.size = AppSizes.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final initials = DisplayHelper.initials(name);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.avatarGradient,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.translucentWhiteBorder, width: 2),
      ),
      child: initials.isEmpty
          ? Icon(
              AppIcons.person,
              color: AppColors.primaryDeep,
              size: size * 0.5,
            )
          : Text(
              initials,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.primaryDeep,
                fontSize: size * 0.36,
              ),
            ),
    );
  }
}
