import '../constants/app_strings.dart';

/// Small pure formatting helpers for user-facing display values.
class DisplayHelper {
  DisplayHelper._();

  /// "Good morning / afternoon / evening" based on the hour of [time].
  static String timeGreeting(DateTime time) {
    if (time.hour < 12) return AppStrings.goodMorning;
    if (time.hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  /// Up to two initials, e.g. "Ali Khan" -> "AK", "ali" -> "A".
  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
