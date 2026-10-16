import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/app/constants/app_colors.dart';
import 'package:todo_app/app/constants/app_icons.dart';
import 'package:todo_app/app/constants/app_sizes.dart';
import 'package:todo_app/app/theme/app_theme.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/shared/widgets/task_card.dart';

TaskModel _task({bool done = false}) => TaskModel(
  id: '1',
  userId: 'u',
  title:
      'A very long task title that must wrap onto two lines and then end '
      'with an ellipsis instead of overflowing the card',
  description: 'A description that is also long enough to be cut off',
  dueDate: DateTime.now().subtract(const Duration(days: 2)),
  priority: TaskPriority.high,
  isCompleted: done,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  late int toggles;
  late int edits;
  late int deletes;

  Future<void> pumpCard(WidgetTester tester, {bool done = false}) async {
    toggles = edits = deletes = 0;
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(AppSizes.gutter),
            child: TaskCard(
              task: _task(done: done),
              onTap: () {},
              onToggle: () => toggles++,
              onEdit: () => edits++,
              onDelete: () => deletes++,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('actions are stacked Edit → Delete → Checkbox on the right', (
    tester,
  ) async {
    await pumpCard(tester);
    expect(tester.takeException(), isNull);

    final edit = tester.getRect(find.widgetWithIcon(IconButton, AppIcons.edit));
    final delete = tester.getRect(
      find.widgetWithIcon(IconButton, AppIcons.delete),
    );
    final checkbox = tester.getRect(find.byType(Checkbox));
    final title = tester.getRect(find.textContaining('A very long task'));

    // One column, top to bottom, to the right of the text.
    expect(edit.center.dx, closeTo(delete.center.dx, 1));
    expect(delete.center.dx, closeTo(checkbox.center.dx, 1));
    expect(edit.top, lessThan(delete.top));
    expect(delete.top, lessThan(checkbox.top));
    expect(title.right, lessThanOrEqualTo(edit.left));

    // Tap targets of at least 40 x 40.
    for (final target in [edit, delete, checkbox]) {
      expect(target.width, greaterThanOrEqualTo(AppSizes.tapTarget));
      expect(target.height, greaterThanOrEqualTo(AppSizes.tapTarget));
    }
  });

  testWidgets('buttons call their callbacks', (tester) async {
    await pumpCard(tester);
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.widgetWithIcon(IconButton, AppIcons.edit));
    await tester.tap(find.widgetWithIcon(IconButton, AppIcons.delete));
    expect([toggles, edits, deletes], [1, 1, 1]);
  });

  testWidgets('completed task: checked box and struck-through title', (
    tester,
  ) async {
    await pumpCard(tester, done: true);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    final title = tester.widget<Text>(find.textContaining('A very long task'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
    expect(title.style?.color, AppColors.completedTaskText);
    expect(title.style?.decorationColor, AppColors.completedTaskText);
    expect(title.style?.decorationThickness, AppSizes.strikeThickness);
    final description = tester.widget<Text>(
      find.textContaining('A description'),
    );
    expect(description.style?.color, AppColors.completedTaskText);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pending task: no strike-through, normal colors', (tester) async {
    await pumpCard(tester);
    final title = tester.widget<Text>(find.textContaining('A very long task'));
    expect(title.style?.decoration, isNot(TextDecoration.lineThrough));
    expect(title.style?.color, AppColors.textPrimary);
  });
}
