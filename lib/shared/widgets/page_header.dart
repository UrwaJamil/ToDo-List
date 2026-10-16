import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import 'curved_header.dart';
import 'soft_icon_button.dart';

/// Curved purple header with an optional back button, a title and subtitle.
/// Used by Add/Edit Task, Task Details, Calendar and Profile.
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showDecoration;

  /// Extra space at the bottom for a card that overlaps the curve.
  final double overlap;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.showDecoration = true,
    this.overlap = AppSizes.cardOverlap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedHeader(
      showDecoration: showDecoration,
      padding: EdgeInsets.fromLTRB(
        AppSizes.gutter,
        AppSizes.l,
        AppSizes.gutter,
        AppSizes.waveDepth + overlap + AppSizes.s,
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            SoftIconButton.onHeader(
              icon: AppIcons.back,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack!,
            ),
            const SizedBox(width: AppSizes.l),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.screenTitle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.secondary.copyWith(
                      color: AppColors.textOnPrimaryMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Keeps the title clear of the decoration on the right.
          if (showDecoration) const SizedBox(width: AppSizes.huge),
        ],
      ),
    );
  }
}
