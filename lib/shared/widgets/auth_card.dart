import 'package:flutter/material.dart';

import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_card.dart';

/// Form card for the auth screens: title, subtitle and the form. Fades and
/// slides up on entry.
class AuthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const AuthCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  static const Duration _entryDuration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    final card = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.screenTitle),
          const SizedBox(height: AppSizes.s),
          Text(subtitle, style: AppTextStyles.secondary),
          const SizedBox(height: AppSizes.xxl),
          child,
        ],
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _entryDuration,
      curve: Curves.easeOutCubic,
      child: card,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, AppSizes.xxl * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}
