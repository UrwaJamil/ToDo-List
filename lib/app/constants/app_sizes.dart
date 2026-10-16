/// Every spacing, radius and fixed dimension used in the UI. Views never
/// hard-code these numbers.
class AppSizes {
  AppSizes._();

  // Spacing scale
  static const double xxs = 2;
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  /// Horizontal page padding.
  static const double gutter = xl;

  // Radius
  static const double radiusXs = 6;
  static const double radiusS = 10;
  static const double radiusM = 14;
  static const double radiusButton = 16;
  static const double radiusChip = 20;
  static const double radiusTaskCard = 20;
  static const double radiusCard = 24;
  static const double radiusSheet = 28;

  // Icons
  static const double iconXs = 14;
  static const double iconS = 16;
  static const double iconM = 20;
  static const double iconL = 24;
  static const double iconXl = 40;

  // Components
  static const double buttonHeight = 54;
  static const double iconButton = 44;
  static const double searchHeight = 52;

  /// Fully rounded: the search bar and the tune button next to it.
  static const double searchRadius = searchHeight / 2;
  static const double avatar = 48;
  static const double avatarLarge = 88;
  static const double statusStrip = 5;
  static const double statIconBox = 36;
  static const double statusDot = 5;
  static const double navIndicatorWidth = 18;
  static const double navIndicatorHeight = 3;
  static const double calendarDay = 40;
  static const double spinner = 22;
  static const double spinnerSmall = 18;

  /// Logo on the auth header (shown directly, no white tile).
  static const double authLogo = 96;

  /// Logo corner radius as a fraction of its size (~26 at 96).
  static const double logoRadiusFactor = 0.27;

  /// Zoom inside the clip so the image's white corners never show.
  static const double logoImageScale = 1.08;
  static const double splashLogo = 110;

  // Header
  /// Depth of the wave at the bottom of the curved header.
  static const double waveDepth = 36;

  /// How far the stat cards hang below the purple header.
  static const double statOverlap = 64;

  /// How far the auth / form cards overlap the header.
  static const double cardOverlap = 40;
  static const double headerDecoration = 96;

  // Empty-state illustration
  static const double illustration = 168;
  static const double emptyActionMaxWidth = 220;

  // Decorative background waves
  static const double backgroundWaveWidth = 260;
  static const double backgroundWaveHeight = 180;

  // Shadows
  static const double shadowBlurSoft = 20;
  static const double shadowOffsetSoft = 8;
  static const double shadowBlurElevated = 24;
  static const double shadowOffsetElevated = 10;

  /// The bottom bar's shadow is cast upwards by this much.
  static const double shadowOffsetUp = 6;
  static const double shadowBlurCard = 28;
  static const double shadowOffsetCard = 12;
  static const double shadowBlurGlow = 22;
  static const double shadowOffsetGlow = 6;

  // Task card action column (edit / delete / checkbox)
  /// Minimum tap target for the compact icon buttons and the checkbox.
  static const double tapTarget = 40;
  static const double taskActionIcon = 21;

  /// Line-through on completed task titles; thick enough to see clearly.
  static const double strikeThickness = 2;

  /// Space between task cards, roomy enough for their shadows.
  static const double cardSpacing = l;

  // Lists
  /// Space left under the last task so the FAB never covers it.
  static const double listBottomForFab = 96;
}
