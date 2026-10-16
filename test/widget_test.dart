import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/data/models/user_model.dart';

TaskModel _task({DateTime? dueDate, bool isCompleted = false}) {
  final now = DateTime(2026, 1, 1, 10);
  return TaskModel(
    id: 'task-1',
    userId: 'user-1',
    title: 'Write report',
    description: 'Lab task',
    dueDate: dueDate ?? DateTime.now().add(const Duration(days: 1)),
    priority: TaskPriority.high,
    isCompleted: isCompleted,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('TaskModel', () {
    test('toMap / fromMap round trip keeps every field', () {
      final task = _task();
      final copy = TaskModel.fromMap(task.toMap(), task.id);

      expect(copy.id, task.id);
      expect(copy.userId, task.userId);
      expect(copy.title, task.title);
      expect(copy.description, task.description);
      expect(copy.dueDate, task.dueDate);
      expect(copy.priority, TaskPriority.high);
      expect(copy.isCompleted, isFalse);
      expect(copy.createdAt, task.createdAt);
      expect(task.toMap()[TaskModel.fieldDueDate], isA<Timestamp>());
    });

    test('copyWith only changes the given fields', () {
      final task = _task();
      final done = task.copyWith(isCompleted: true);

      expect(done.isCompleted, isTrue);
      expect(done.title, task.title);
      expect(done.id, task.id);
    });

    test('isOverdue is true only for past, unfinished tasks', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      expect(_task(dueDate: yesterday).isOverdue, isTrue);
      expect(_task(dueDate: yesterday, isCompleted: true).isOverdue, isFalse);
      expect(_task(dueDate: DateTime.now()).isOverdue, isFalse);
    });

    test('unknown priority falls back to medium', () {
      expect(TaskPriority.fromName('urgent'), TaskPriority.medium);
      expect(TaskPriority.fromName('low'), TaskPriority.low);
    });
  });

  test('UserModel map never contains a password', () {
    final user = UserModel(
      uid: 'u1',
      name: 'Ali',
      email: 'ali@example.com',
      createdAt: DateTime(2026, 1, 1),
    );
    final map = user.toMap();

    expect(map.containsKey('password'), isFalse);
    expect(UserModel.fromMap(map).email, 'ali@example.com');
  });
}
