import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../app/constants/app_strings.dart';
import '../../app/utils/date_formatter.dart';
import '../models/task_model.dart';

/// Local (on-device) task reminders: one notification at 9:00 AM the day
/// before a pending task is due. Contains no UI code; controllers decide when
/// to schedule or cancel, and listen to [onTaskTapped] to navigate.
class NotificationService extends GetxService {
  static const String channelId = 'task_reminders';
  static const int reminderHour = 9;

  /// Used if 9:00 AM the day before has already passed.
  static const Duration immediateDelay = Duration(minutes: 1);

  /// White monochrome drawable in android/app/src/main/res/drawable.
  static const String _androidIcon = 'ic_notification';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _taps = StreamController<String>.broadcast();

  bool _isReady = false;
  String? _launchTaskId;

  /// Task IDs from reminders tapped while the app is running.
  Stream<String> get onTaskTapped => _taps.stream;

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      AppStrings.reminderChannelName,
      channelDescription: AppStrings.reminderChannelDescription,
      icon: _androidIcon,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  // ------------------------------------------------------------------ setup

  /// Called from main() before runApp. Never throws: if notifications are not
  /// supported (e.g. desktop) every other method silently does nothing.
  Future<void> init() async {
    try {
      await _initTimeZone();
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(_androidIcon),
          // Permission is requested after login, not on app start.
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: _onTap,
      );
      await _androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          channelId,
          AppStrings.reminderChannelName,
          description: AppStrings.reminderChannelDescription,
          importance: Importance.high,
        ),
      );

      // App was started by tapping a reminder (it was not running).
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        _launchTaskId = _taskIdFrom(launch?.notificationResponse?.payload);
      }
      _isReady = true;
    } catch (e) {
      debugPrint('NotificationService init failed: $e');
    }
  }

  /// Loads the timezone database and sets tz.local to the device's zone, so
  /// scheduled reminders follow local time (including daylight saving).
  Future<void> _initTimeZone() async {
    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Unknown zone name: tz.local stays UTC. Reminder instants are still
      // correct because they are built from the device's local DateTime.
    }
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  void _onTap(NotificationResponse response) {
    final taskId = _taskIdFrom(response.payload);
    if (taskId != null) _taps.add(taskId);
  }

  static String? _taskIdFrom(String? payload) =>
      (payload == null || payload.isEmpty) ? null : payload;

  /// The task whose reminder launched the app, returned only once.
  String? takeLaunchTaskId() {
    final id = _launchTaskId;
    _launchTaskId = null;
    return id;
  }

  /// Asks for notification permission (Android 13+ / iOS). Call after login
  /// or sign-up, not on app start.
  Future<void> requestPermission() async {
    if (!_isReady) return;
    try {
      await _androidPlugin?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e) {
      debugPrint('Notification permission request failed: $e');
    }
  }

  // ------------------------------------------------------------- scheduling

  /// When [task]'s reminder should fire, or null for no reminder.
  ///
  /// - Completed tasks, or tasks whose due date is not after [now]: null.
  /// - Normally 9:00 AM local time on the day before the due date.
  /// - If that has passed but the task is still due in the future, [now] + 1
  ///   minute when [allowImmediate] is true, otherwise null.
  static DateTime? reminderTimeFor(
    TaskModel task,
    DateTime now, {
    bool allowImmediate = true,
  }) {
    if (task.isCompleted || !task.dueDate.isAfter(now)) return null;
    final due = task.dueDate;
    final dayBefore = DateTime(due.year, due.month, due.day - 1, reminderHour);
    if (dayBefore.isAfter(now)) return dayBefore;
    return allowImmediate ? now.add(immediateDelay) : null;
  }

  /// Stable, positive notification ID for a Firestore task ID. Uses FNV-1a
  /// rather than String.hashCode, which Dart does not promise is the same
  /// across app runs. Never 0, so every ID is strictly positive.
  static int reminderIdFor(String taskId) {
    var hash = 0x811c9dc5;
    for (final unit in taskId.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    final id = hash & 0x7fffffff;
    return id == 0 ? 1 : id;
  }

  /// Schedules (or replaces) the reminder for [task]. Does nothing when
  /// [reminderTimeFor] returns null. Uses inexact alarms, so the
  /// SCHEDULE_EXACT_ALARM permission is not needed.
  Future<void> scheduleTaskReminder(
    TaskModel task, {
    bool allowImmediate = true,
  }) async {
    if (!_isReady || task.id.isEmpty) return;
    final at = reminderTimeFor(
      task,
      DateTime.now(),
      allowImmediate: allowImmediate,
    );
    if (at == null) return;
    try {
      await _plugin.zonedSchedule(
        id: reminderIdFor(task.id),
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: AppStrings.reminderTitle,
        body: AppStrings.reminderBody(
          task.title,
          DateFormatter.date(task.dueDate),
        ),
        payload: task.id,
      );
    } catch (e) {
      debugPrint('Could not schedule reminder for ${task.id}: $e');
    }
  }

  /// Removes the scheduled reminder (and the shown one, if any) of a task.
  Future<void> cancelTaskReminder(String taskId) async {
    if (!_isReady || taskId.isEmpty) return;
    try {
      await _plugin.cancel(id: reminderIdFor(taskId));
    } catch (e) {
      debugPrint('Could not cancel reminder for $taskId: $e');
    }
  }

  /// Removes every scheduled and shown notification (used on logout).
  Future<void> cancelAll() async {
    if (!_isReady) return;
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Could not cancel notifications: $e');
    }
  }

  /// Rebuilds all scheduled reminders from [tasks], e.g. after login or when
  /// tasks were added on another device.
  ///
  /// Only pending (not yet shown) notifications are cleared, and the
  /// "1 minute from now" fallback is not used here. Otherwise every app start
  /// would re-send a reminder for a task that is due tomorrow.
  Future<void> syncReminders(List<TaskModel> tasks) async {
    if (!_isReady) return;
    try {
      await _plugin.cancelAllPendingNotifications();
    } catch (e) {
      debugPrint('Could not clear pending reminders: $e');
    }
    for (final task in tasks) {
      await scheduleTaskReminder(task, allowImmediate: false);
    }
  }

  @override
  void onClose() {
    _taps.close();
    super.onClose();
  }
}
