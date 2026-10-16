import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Purple-tinted shadows shared by the whole app. Use [soft] for things that
/// sit on the page and [elevated] for things that float above it.
class AppShadows {
  AppShadows._();

  /// Search bar, tune button, filter chips, task cards.
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.shadowSoft,
      blurRadius: AppSizes.shadowBlurSoft,
      offset: Offset(0, AppSizes.shadowOffsetSoft),
    ),
  ];

  /// [soft] with a little more opacity, for the selected filter chip.
  static const List<BoxShadow> softStrong = [
    BoxShadow(
      color: AppColors.shadowSoftStrong,
      blurRadius: AppSizes.shadowBlurSoft,
      offset: Offset(0, AppSizes.shadowOffsetSoft),
    ),
  ];

  /// Floating elements: the Add Task button.
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: AppColors.shadowElevated,
      blurRadius: AppSizes.shadowBlurElevated,
      offset: Offset(0, AppSizes.shadowOffsetElevated),
    ),
  ];

  /// [elevated], cast upwards, for the bottom navigation bar.
  static const List<BoxShadow> elevatedUp = [
    BoxShadow(
      color: AppColors.shadowElevated,
      blurRadius: AppSizes.shadowBlurElevated,
      offset: Offset(0, -AppSizes.shadowOffsetUp),
    ),
  ];

  /// Larger cards (stat cards, form / details cards).
  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: AppSizes.shadowBlurCard,
      offset: Offset(0, AppSizes.shadowOffsetCard),
    ),
  ];

  /// Glow under gradient buttons and small badges.
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: AppColors.shadowGlow,
      blurRadius: AppSizes.shadowBlurGlow,
      offset: Offset(0, AppSizes.shadowOffsetGlow),
    ),
  ];
}
