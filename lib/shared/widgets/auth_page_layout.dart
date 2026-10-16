import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import 'auth_card.dart';
import 'auth_header.dart';
import 'header_card_layout.dart';

/// Page skeleton shared by Login, Sign-Up and Forgot Password: curved
/// [AuthHeader], an [AuthCard] overlapping it, and a link below.
class AuthPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Widget bottomLink;

  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.bottomLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: HeaderCardLayout(
        header: const AuthHeader(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthCard(title: title, subtitle: subtitle, child: form),
            const SizedBox(height: AppSizes.xl),
            SafeArea(top: false, child: bottomLink),
          ],
        ),
      ),
    );
  }
}
