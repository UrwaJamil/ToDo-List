import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Every text style in the app, named by role. Headings use Plus Jakarta
/// Sans, body text uses Inter (both bundled in assets/google_fonts).
///
/// google_fonts bakes the weight into the font family, so change only the
/// color with copyWith; pick another style here to change the weight. Only
/// these weights are bundled: Jakarta 600/700/800 and Inter 400/500/600.
///
/// Sizes are chosen for readability: nothing is smaller than [minSize].
class AppTextStyles {
  AppTextStyles._();

  static const double minSize = 12;

  static TextStyle _jakarta(double size, FontWeight weight, {double? height}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: AppColors.textPrimary,
      );

  static TextStyle _inter(
    double size,
    FontWeight weight, {
    double? height,
    Color color = AppColors.textPrimary,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
  );

  // ------------------------------------------- headings (Plus Jakarta Sans)

  /// Splash app name.
  static TextStyle get display => _jakarta(32, FontWeight.w800);

  /// Screen titles: "My Tasks", page headers, auth card titles.
  static TextStyle get screenTitle =>
      _jakarta(30, FontWeight.w800, height: 1.15);

  /// Large names inside content: profile name, task title on Details.
  static TextStyle get headline => _jakarta(24, FontWeight.w800, height: 1.2);

  /// User name in the Home header.
  static TextStyle get headerName => _jakarta(20, FontWeight.w700);

  /// Section titles: month label, "Due …", empty-state and dialog titles.
  static TextStyle get sectionTitle => _jakarta(18, FontWeight.w700);

  /// Task titles and card titles.
  static TextStyle get cardTitle => _jakarta(17, FontWeight.w700);

  /// Same size as [cardTitle], semibold (Material titleMedium).
  static TextStyle get cardTitleSemi => _jakarta(17, FontWeight.w600);

  static TextStyle get statNumber => _jakarta(28, FontWeight.w800, height: 1.1);

  /// Form field labels and text links ("Sign Up").
  static TextStyle get label => _jakarta(15, FontWeight.w600);

  static TextStyle get button => _jakarta(16, FontWeight.w700);

  // ----------------------------------------------------------- body (Inter)

  static TextStyle get bodyLarge => _inter(16, FontWeight.w500);

  /// Body text and form input text (dark).
  static TextStyle get body => _inter(15, FontWeight.w500, height: 1.4);

  /// Body-size supporting text: descriptions, messages (dark grey).
  static TextStyle get bodyMuted =>
      _inter(15, FontWeight.w500, height: 1.4, color: AppColors.textSecondary);

  static TextStyle get bodySemi => _inter(15, FontWeight.w600);

  /// Dates, due dates, helper text, subtitles (dark grey).
  static TextStyle get secondary =>
      _inter(14, FontWeight.w500, color: AppColors.textSecondary);

  static TextStyle get secondarySemi =>
      _inter(14, FontWeight.w600, color: AppColors.textSecondary);

  /// Stat card labels ("Total", "Completed", "Pending").
  static TextStyle get statLabel =>
      _inter(14, FontWeight.w600, color: AppColors.textSecondary);

  /// Filter chips (All / Pending / Completed).
  static TextStyle get chip =>
      _inter(14, FontWeight.w600, color: AppColors.chipText);

  /// Small badges: priority, status, overdue; calendar weekday headers.
  static TextStyle get badge => _inter(13, FontWeight.w600);

  static TextStyle get navLabel =>
      _inter(13, FontWeight.w500, color: AppColors.textHint);

  static TextStyle get navLabelActive =>
      _inter(13, FontWeight.w600, color: AppColors.primary);

  /// The smallest text allowed anywhere.
  static TextStyle get smallest =>
      _inter(minSize, FontWeight.w500, color: AppColors.textSecondary);

  /// Material text theme, so framework widgets (dialogs, date picker, menus,
  /// snackbars) use the same fonts and sizes.
  static TextTheme get textTheme => TextTheme(
    displayLarge: _jakarta(48, FontWeight.w800),
    displayMedium: _jakarta(40, FontWeight.w800),
    displaySmall: display,
    headlineLarge: screenTitle,
    headlineMedium: headline,
    headlineSmall: headerName,
    titleLarge: headerName,
    titleMedium: cardTitleSemi,
    titleSmall: label,
    bodyLarge: bodyLarge,
    bodyMedium: _inter(15, FontWeight.w500),
    bodySmall: secondary,
    labelLarge: bodySemi,
    labelMedium: secondarySemi,
    labelSmall: smallest,
  );
}
