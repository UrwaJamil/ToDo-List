import 'package:intl/intl.dart';

/// Single place for date formatting so every screen shows dates the same way.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _date = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _weekdayDayMonth = DateFormat('EEEE, d MMM');
  static final DateFormat _reminder = DateFormat('EEE, d MMM, h:mm a');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _weekdayShort = DateFormat('EEE');

  /// e.g. "October 2026".
  static String monthYear(DateTime value) => _monthYear.format(value);

  /// e.g. "Mon".
  static String weekdayShort(DateTime value) => _weekdayShort.format(value);

  static String date(DateTime value) => _date.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value);

  /// e.g. "Friday, 16 Oct".
  static String weekdayDayMonth(DateTime value) =>
      _weekdayDayMonth.format(value);

  /// e.g. "Thu, 15 Oct, 9:00 AM".
  static String reminder(DateTime value) => _reminder.format(value);
}
