import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/bindings/main_shell_binding.dart';
import 'package:todo_app/app/constants/app_colors.dart';
import 'package:todo_app/app/constants/app_sizes.dart';
import 'package:todo_app/app/constants/app_strings.dart';
import 'package:todo_app/app/routes/app_pages.dart';
import 'package:todo_app/app/routes/app_routes.dart';
import 'package:todo_app/app/theme/app_theme.dart';
import 'package:todo_app/app/utils/display_helper.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/services/auth_service.dart';
import 'package:todo_app/data/services/notification_service.dart';
import 'package:todo_app/data/services/task_service.dart';
import 'package:todo_app/modules/auth/controllers/auth_controller.dart';
import 'package:todo_app/modules/calendar/views/calendar_view.dart';
import 'package:todo_app/modules/home/controllers/home_controller.dart';
import 'package:todo_app/modules/home/views/widgets/sort_menu_button.dart';
import 'package:todo_app/modules/profile/views/profile_view.dart';
import 'package:todo_app/modules/shell/controllers/main_shell_controller.dart';
import 'package:todo_app/modules/shell/views/main_shell_view.dart';
import 'package:todo_app/shared/widgets/stat_card.dart';
import 'package:todo_app/shared/widgets/task_card.dart';

const _longName =
    'Muhammad Abdullah Rehman Siddiqui Khan The Very Long Named Student';
const _email = 'a.very.long.email.address.for.testing@university-example.edu';

class _FakeUser implements User {
  _FakeUser(this.displayName, this.email);

  @override
  final String? displayName;

  @override
  final String? email;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeAuthService extends GetxService implements AuthService {
  _FakeAuthService(this._user);

  final User _user;

  @override
  User? get currentUser => _user;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Serves a fixed task list instead of Firestore.
class _FakeTaskService extends GetxService implements TaskService {
  _FakeTaskService(this.tasks);

  final List<TaskModel> tasks;

  @override
  Stream<List<TaskModel>> streamTasks() => Stream.value(tasks);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeNotificationService extends GetxService
    implements NotificationService {
  @override
  Future<void> syncReminders(List<TaskModel> tasks) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

TaskModel _task(
  int i, {
  required DateTime due,
  bool done = false,
  String? title,
}) => TaskModel(
  id: '$i',
  userId: 'u',
  title: title ?? 'A rather long task title number $i that should wrap nicely',
  description: 'Some description text for this task',
  dueDate: due,
  priority: TaskPriority.values[i % 3],
  isCompleted: done,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

List<TaskModel> _sampleTasks() {
  final today = _today();
  return [
    _task(1, due: today, title: 'Due today task'),
    _task(2, due: today.add(const Duration(days: 1)), title: 'Pending task'),
    _task(
      3,
      due: today.add(const Duration(days: 2)),
      done: true,
      title: 'Finished task',
    ),
    _task(4, due: today.subtract(const Duration(days: 3))),
    for (var i = 5; i < 10; i++)
      _task(
        i,
        due: today.add(Duration(days: i)),
        done: i.isEven,
      ),
  ];
}

Future<void> _pumpShell(
  WidgetTester tester, {
  List<TaskModel>? tasks,
  double textScale = 1,
}) async {
  final auth = Get.put<AuthService>(
    _FakeAuthService(_FakeUser(_longName, _email)),
  );
  Get.put<TaskService>(_FakeTaskService(tasks ?? _sampleTasks()));
  final notifications = Get.put<NotificationService>(
    _FakeNotificationService(),
  );
  Get.put(AuthController(auth, notifications));
  MainShellBinding().dependencies();

  await tester.pumpWidget(
    GetMaterialApp(
      theme: AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const MainShellView(),
      // Real routes, so Task Details / Add Task open with their bindings.
      getPages: AppPages.routes,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openTab(WidgetTester tester, ShellTab tab) async {
  await tester.tap(find.text(tab.label));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio()
      ..resetViewInsets();
    Get.reset();
  });

  group('home', () {
    testWidgets('no overflow at 360px with a long name and many tasks', (
      tester,
    ) async {
      await _pumpShell(tester);
      expect(tester.takeException(), isNull);
      expect(find.text(_longName), findsOneWidget);
      expect(find.text(AppStrings.myTasks), findsOneWidget);
      expect(find.byType(StatCard), findsNWidgets(3));

      // Scroll through the whole list to lay out every card.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty state', (tester) async {
      await _pumpShell(tester, tasks: const []);
      expect(tester.takeException(), isNull);
      expect(find.text(AppStrings.noTasksTitle), findsOneWidget);
    });

    testWidgets('no overflow with large text', (tester) async {
      await _pumpShell(tester, textScale: 1.3);
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow with the keyboard open', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await _pumpShell(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('stat cards set the filter', (tester) async {
      await _pumpShell(tester);
      final home = Get.find<HomeController>();

      await tester.tap(find.text(AppStrings.completed).first);
      await tester.pumpAndSettle();
      expect(home.filter.value, TaskFilter.completed);
      expect(home.filteredTasks, isNotEmpty);
      expect(home.filteredTasks.every((task) => task.isCompleted), isTrue);
      expect(find.text('Pending task'), findsNothing);

      await tester.tap(find.byType(StatCard).last);
      await tester.pumpAndSettle();
      expect(home.filter.value, TaskFilter.pending);

      await tester.tap(find.byType(StatCard).first);
      await tester.pumpAndSettle();
      expect(home.filter.value, TaskFilter.all);
    });

    testWidgets('search without matches shows the no-results state', (
      tester,
    ) async {
      await _pumpShell(tester);
      await tester.enterText(find.byType(TextField), 'zzz no such task');
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.noResultsTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sort menu lists both options', (tester) async {
      await _pumpShell(tester);
      await tester.tap(find.byType(SortMenuButton));
      await tester.pumpAndSettle();
      expect(
        find.text(AppStrings.sortBy(AppStrings.sortPriority)),
        findsOneWidget,
      );
      expect(
        find.text(AppStrings.sortBy(AppStrings.sortDueDate)),
        findsOneWidget,
      );
    });
  });

  group('task screens', () {
    final longTask = _task(
      42,
      due: _today().subtract(const Duration(days: 2)),
      title:
          'An extremely long task title that keeps going to check that the '
          'details screen wraps it instead of overflowing on a small phone',
    );

    for (final scale in [1.0, 1.3]) {
      testWidgets('details: no overflow at 360px (text x$scale)', (
        tester,
      ) async {
        await _pumpShell(tester, tasks: [longTask], textScale: scale);
        Get.toNamed(Routes.TASK_DETAILS, arguments: longTask);
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.taskDetails), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byType(SingleChildScrollView).last,
          const Offset(0, -2000),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('add task: no overflow at 360px (text x$scale)', (
        tester,
      ) async {
        await _pumpShell(tester, textScale: scale);
        Get.toNamed(Routes.ADD_TASK);
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.saveTask), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('add task: no overflow with the keyboard open', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await _pumpShell(tester);
      Get.toNamed(Routes.ADD_TASK);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('bottom navigation', () {
    testWidgets('calendar lists the tasks due on the selected day', (
      tester,
    ) async {
      await _pumpShell(tester);
      await _openTab(tester, ShellTab.calendar);
      expect(tester.takeException(), isNull);
      expect(Get.find<MainShellController>().currentTab, ShellTab.calendar);
      expect(find.byType(CalendarView), findsOneWidget);

      // Today is selected by default.
      final todayCards = find.descendant(
        of: find.byType(CalendarView),
        matching: find.byType(TaskCard),
      );
      expect(todayCards, findsOneWidget);
      expect(find.text('Due today task'), findsOneWidget);

      // Tomorrow (may be in next month).
      final tomorrow = _today().add(const Duration(days: 1));
      if (tomorrow.month != _today().month) {
        await tester.tap(find.byTooltip(AppStrings.nextMonth));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('${tomorrow.day}').last);
      await tester.pumpAndSettle();
      expect(find.text('Pending task'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('calendar dots use status colors and follow the data', (
      tester,
    ) async {
      final today = _today();
      // Same month as today, so no month navigation is needed.
      final pendingDay = today.day < 28
          ? today.add(const Duration(days: 1))
          : today;
      final doneDay = today.day > 1
          ? today.subtract(const Duration(days: 1))
          : null;
      await _pumpShell(
        tester,
        tasks: [
          _task(1, due: pendingDay, title: 'Open task'),
          if (doneDay != null) _task(2, due: doneDay, done: true),
        ],
      );
      await _openTab(tester, ShellTab.calendar);

      List<Color?> dotColors() => tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(CalendarView),
              matching: find.byType(Container),
            ),
          )
          .where(
            (c) =>
                c.constraints?.maxWidth == AppSizes.statusDot &&
                c.decoration is BoxDecoration &&
                (c.decoration! as BoxDecoration).shape == BoxShape.circle,
          )
          .map((c) => (c.decoration! as BoxDecoration).color)
          .where((color) => color != AppColors.transparent)
          .toList();

      // Built before the tasks loaded; the dots must still appear.
      final colors = dotColors();
      if (pendingDay != today) expect(colors, contains(AppColors.pending));
      if (doneDay != null) expect(colors, contains(AppColors.completed));

      // Tapping a day moves the highlight (and its dot turns white).
      await tester.tap(find.text('${pendingDay.day}').first);
      await tester.pumpAndSettle();
      expect(dotColors(), contains(AppColors.white));
      expect(find.text('Open task'), findsOneWidget);
    });

    testWidgets('calendar has no overflow with large text', (tester) async {
      await _pumpShell(tester, textScale: 1.3);
      await _openTab(tester, ShellTab.calendar);
      await tester.drag(
        find.descendant(
          of: find.byType(CalendarView),
          matching: find.byType(SingleChildScrollView),
        ),
        const Offset(0, -2000),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('profile shows the user and its stats open Home', (
      tester,
    ) async {
      await _pumpShell(tester);
      await _openTab(tester, ShellTab.profile);
      expect(tester.takeException(), isNull);
      expect(find.text(_longName), findsOneWidget);
      expect(find.text(_email), findsOneWidget);
      expect(find.text(AppStrings.logout), findsOneWidget);

      final profileStats = find.descendant(
        of: find.byType(ProfileView),
        matching: find.byType(StatCard),
      );
      expect(profileStats, findsNWidgets(3));

      await tester.tap(profileStats.last);
      await tester.pumpAndSettle();
      expect(Get.find<MainShellController>().currentTab, ShellTab.home);
      expect(Get.find<HomeController>().filter.value, TaskFilter.pending);
    });

    testWidgets('profile has no overflow with large text', (tester) async {
      await _pumpShell(tester, textScale: 1.3);
      await _openTab(tester, ShellTab.profile);
      expect(tester.takeException(), isNull);
    });
  });

  test('display helper initials and greeting', () {
    expect(DisplayHelper.initials('Ali Khan Raza'), 'AK');
    expect(DisplayHelper.initials('  ali '), 'A');
    expect(DisplayHelper.initials(''), '');
    expect(
      DisplayHelper.timeGreeting(DateTime(2026, 1, 1, 9)),
      AppStrings.goodMorning,
    );
    expect(
      DisplayHelper.timeGreeting(DateTime(2026, 1, 1, 14)),
      AppStrings.goodAfternoon,
    );
    expect(
      DisplayHelper.timeGreeting(DateTime(2026, 1, 1, 20)),
      AppStrings.goodEvening,
    );
  });
}
