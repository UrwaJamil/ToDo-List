import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// "Don't have an account? Sign Up" style link shared by Login and Sign-Up.
class AuthSwitchLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap (not Row) so the link drops to a second line on narrow screens
    // or with large text instead of overflowing.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          question,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMuted,
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: AppTextStyles.label.copyWith(color: AppColors.purpleText),
          ),
        ),
      ],
    );
  }
}
