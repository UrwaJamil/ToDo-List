import 'package:flutter/material.dart';

/// Every icon used in the app. Views never reference [Icons] directly.
class AppIcons {
  AppIcons._();

  static const IconData logo = Icons.task_alt_rounded;

  // Auth
  static const IconData person = Icons.person_outline_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline_rounded;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData logout = Icons.logout_rounded;
  static const IconData emailAvailable = Icons.check_circle_rounded;
  static const IconData emailTaken = Icons.cancel_rounded;
  static const IconData ruleMet = Icons.check_circle_rounded;
  static const IconData ruleUnmet = Icons.radio_button_unchecked_rounded;
  static const IconData mailSent = Icons.mark_email_read_outlined;

  // Tasks
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData title = Icons.title_rounded;
  static const IconData description = Icons.notes_rounded;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData flag = Icons.flag_rounded;
  static const IconData time = Icons.access_time_rounded;
  static const IconData update = Icons.update_rounded;
  static const IconData overdue = Icons.alarm_rounded;
  static const IconData save = Icons.check_rounded;
  static const IconData markDone = Icons.check_circle_outline_rounded;
  static const IconData markPending = Icons.replay_rounded;
  static const IconData reminder = Icons.notifications_active_outlined;
  static const IconData noReminder = Icons.notifications_off_outlined;

  // Home
  static const IconData search = Icons.search_rounded;
  static const IconData clear = Icons.close_rounded;
  static const IconData sort = Icons.tune_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData total = Icons.format_list_bulleted_rounded;
  static const IconData completed = Icons.check_circle_rounded;
  static const IconData pending = Icons.schedule_rounded;
  static const IconData statArrow = Icons.arrow_forward_rounded;

  // Navigation
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData navHome = Icons.home_rounded;
  static const IconData navCalendar = Icons.calendar_month_rounded;
  static const IconData navProfile = Icons.person_rounded;
  static const IconData chevronLeft = Icons.chevron_left_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;

  // States
  static const IconData empty = Icons.add_rounded;
  static const IconData noResults = Icons.search_off_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData success = Icons.check_circle_rounded;
  static const IconData retry = Icons.refresh_rounded;
}
