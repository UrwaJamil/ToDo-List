import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/services/notification_service.dart';

TaskModel _task({required DateTime dueDate, bool isCompleted = false}) {
  final created = DateTime(2026, 10, 1);
  return TaskModel(
    id: 'abc123',
    userId: 'u1',
    title: 'Submit lab',
    description: '',
    dueDate: dueDate,
    priority: TaskPriority.medium,
    isCompleted: isCompleted,
    createdAt: created,
    updatedAt: created,
  );
}

void main() {
  // Due dates come from the date picker, so they are at midnight.
  final due = DateTime(2026, 10, 16);

  group('NotificationService.reminderTimeFor', () {
    test('9:00 AM the day before the due date', () {
      final now = DateTime(2026, 10, 10, 18);
      expect(
        NotificationService.reminderTimeFor(_task(dueDate: due), now),
        DateTime(2026, 10, 15, 9),
      );
    });

    test('works across a month boundary', () {
      final now = DateTime(2026, 10, 20);
      expect(
        NotificationService.reminderTimeFor(
          _task(dueDate: DateTime(2026, 11, 1)),
          now,
        ),
        DateTime(2026, 10, 31, 9),
      );
    });

    test('1 minute from now if 9:00 AM already passed but still due', () {
      final now = DateTime(2026, 10, 15, 22, 30); // the night before
      expect(
        NotificationService.reminderTimeFor(_task(dueDate: due), now),
        now.add(const Duration(minutes: 1)),
      );
    });

    test('no fallback when allowImmediate is false (used by sync)', () {
      final now = DateTime(2026, 10, 15, 22, 30);
      expect(
        NotificationService.reminderTimeFor(
          _task(dueDate: due),
          now,
          allowImmediate: false,
        ),
        isNull,
      );
    });

    test('nothing for completed tasks', () {
      final now = DateTime(2026, 10, 10);
      expect(
        NotificationService.reminderTimeFor(
          _task(dueDate: due, isCompleted: true),
          now,
        ),
        isNull,
      );
    });

    test('nothing once the due date has passed', () {
      expect(
        NotificationService.reminderTimeFor(
          _task(dueDate: due),
          DateTime(2026, 10, 16, 8),
        ),
        isNull,
      );
      expect(
        NotificationService.reminderTimeFor(
          _task(dueDate: due),
          DateTime(2026, 10, 20),
        ),
        isNull,
      );
    });
  });

  group('NotificationService.reminderIdFor', () {
    test('is stable and positive', () {
      final id = NotificationService.reminderIdFor('abc123');
      expect(id, NotificationService.reminderIdFor('abc123'));
      expect(id, greaterThan(0));
      expect(id, lessThanOrEqualTo(0x7fffffff));
    });

    test('differs between task IDs and is always positive', () {
      final ids = {
        for (final taskId in ['a', 'b', 'task-1', 'task-2', 'XyZ9'])
          NotificationService.reminderIdFor(taskId),
      };
      expect(ids.length, 5);
      expect(ids.every((id) => id > 0), isTrue);
    });
  });
}
