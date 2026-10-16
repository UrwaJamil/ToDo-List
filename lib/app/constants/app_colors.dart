import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';

/// Every color used in the app. Views never hard-code a [Color].
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryDeep = Color(0xFF4C1D95);
  static const Color primaryLight = Color(0xFFEDE9FE);
  static const Color secondary = Color(0xFFA78BFA);
  static const Color lavender = secondary;
  static const Color lavenderSoft = Color(0xFFC4B5FD);
  static const Color lavenderPale = Color(0xFFDDD6FE);

  // Accents
  static const Color mint = Color(0xFF34D399);
  static const Color mintDark = Color(0xFF059669);
  static const Color mintTint = Color(0xFFE3FAF1);
  // Butter yellow (Total stat card)
  static const Color butterTint = Color(0xFFFEF5D4);
  static const Color butterGradientStart = Color(0xFFFFFBEB);
  static const Color butterGradientEnd = Color(0xFFFEF5D4);
  static const Color butterIconBox = Color(0xFFFDF0C2);
  static const Color butterDark = Color(0xFFB7791F);

  // Sky blue (Pending status + Pending stat card)
  static const Color sky = Color(0xFF0284C7);
  static const Color skyTint = Color(0xFFE0F2FE);
  static const Color skyGradientStart = Color(0xFFEFF8FF);
  static const Color skyGradientEnd = Color(0xFFCDEBFD);
  static const Color skyIconBox = Color(0xFFBAE6FD);
  static const Color skyText = Color(0xFF0369A1);

  // Surfaces
  static const Color background = Color(0xFFF8F7FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = primaryLight;
  static const Color headerDark = Color(0xFF1E1B4B);
  static const Color border = Color(0xFFE9E5F5);
  static const Color inputFill = Color(0xFFF8F7FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // Purple-tinted shadows (#7C3AED at different opacities)
  /// ~16%: search bar, tune button, chips, task cards.
  static const Color shadowSoft = Color(0x297C3AED);

  /// ~22%: the selected filter chip.
  static const Color shadowSoftStrong = Color(0x387C3AED);

  /// ~30%: floating elements (Add Task button, bottom navigation bar).
  static const Color shadowElevated = Color(0x4D7C3AED);
  static const Color shadowCard = Color(0x1F7C3AED);
  static const Color shadowGlow = Color(0x597C3AED);

  // On the purple header
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Greeting, dates and subtitles on the purple header: white at ~88%.
  static const Color textOnPrimaryMuted = Color(0xE0FFFFFF);
  static const Color translucentWhite = Color(0x26FFFFFF);
  static const Color translucentWhiteBorder = Color(0x33FFFFFF);
  static const Color sparkle = Color(0xCCFFFFFF);
  static const Color leafLight = Color(0x8CC4B5FD);
  static const Color leafDark = Color(0x66A78BFA);
  static const Color decorativeCircle = Color(0x1AFFFFFF);

  // Decorative background waves (bottom-left of lists)
  static const Color waveLight = Color(0x80EDE9FE);
  static const Color waveDeep = Color(0x4DDDD6FE);

  // Text on light backgrounds
  static const Color textPrimary = headerDark;

  /// Dates, subtitles, descriptions, helper text.
  static const Color textSecondary = Color(0xFF4B5563);

  /// Placeholders, inactive icons and inactive bottom-nav items.
  static const Color textHint = Color(0xFF6B7280);

  /// Disabled text only.
  static const Color textDisabled = Color(0xFF9CA3AF);

  /// Unselected filter chip text.
  static const Color chipText = Color(0xFF374151);

  // Dark text shades for colored labels on light tints (contrast-safe).
  static const Color greenText = Color(0xFF047857);
  static const Color orangeText = Color(0xFFB45309);
  static const Color redText = Color(0xFFB91C1C);
  static const Color purpleText = Color(0xFF5B21B6);

  // Feedback
  static const Color success = mint;
  static const Color successDark = greenText;
  static const Color successLight = mintTint;
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = redText;
  static const Color errorLight = Color(0xFFFFECEC);

  // Snackbar backgrounds (white text on top)
  static const Color snackbarSuccess = greenText;
  static const Color snackbarError = redText;

  // Password requirement checklist
  static const Color ruleMet = greenText;
  static const Color ruleUnmet = textHint;

  // Task status: main color (strip, dot), light background, text on it.
  static const Color completed = mint;
  static const Color pending = sky;
  static const Color overdue = error;
  static const Color pendingTint = skyTint;
  static const Color completedText = greenText;
  static const Color pendingText = skyText;
  static const Color overdueText = redText;

  /// Title / description of a completed task (with the line-through).
  static const Color completedTaskText = Color(0xFF6B7280);

  // Priority
  static const Color priorityHigh = Color(0xFFF43F5E);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);

  // Stat cards: icon / arrow color, background tint, icon square background
  static const Color statTotal = butterDark;
  static const Color statTotalTint = butterTint;
  static const Color statTotalIconBox = butterIconBox;
  static const Color statCompleted = mintDark;
  static const Color statCompletedTint = mintTint;
  static const Color statCompletedIconBox = surface;
  static const Color statPending = skyText;
  static const Color statPendingTint = skyTint;
  static const Color statPendingIconBox = skyIconBox;

  /// Number and label on the Total / Pending cards.
  static const Color statText = textPrimary;

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryDeep, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Buttons and the Add Task FAB.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient avatarGradient = LinearGradient(
    colors: [lavenderPale, lavender],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient totalTintGradient = LinearGradient(
    colors: [butterGradientStart, butterGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pendingTintGradient = LinearGradient(
    colors: [skyGradientStart, skyGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return priorityHigh;
      case TaskPriority.medium:
        return priorityMedium;
      case TaskPriority.low:
        return priorityLow;
    }
  }

  /// Darker shade of [priorityColor] for the chip's text and icon.
  static Color priorityTextColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return redText;
      case TaskPriority.medium:
        return orangeText;
      case TaskPriority.low:
        return greenText;
    }
  }

  /// Color of the status strip on a task: completed, overdue or pending.
  static Color statusColor(TaskModel task) {
    if (task.isCompleted) return completed;
    if (task.isOverdue) return overdue;
    return pending;
  }
}
