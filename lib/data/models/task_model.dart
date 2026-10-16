import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app/constants/app_strings.dart';

/// Task priority. [weight] is used for sorting (higher = more important).
enum TaskPriority {
  low(1, AppStrings.priorityLow),
  medium(2, AppStrings.priorityMedium),
  high(3, AppStrings.priorityHigh);

  const TaskPriority(this.weight, this.label);

  final int weight;
  final String label;

  static TaskPriority fromName(String? name) => TaskPriority.values.firstWhere(
    (priority) => priority.name == name,
    orElse: () => TaskPriority.medium,
  );
}

class TaskModel {
  // Firestore field names, shared with TaskService.
  static const String fieldUserId = 'userId';
  static const String fieldTitle = 'title';
  static const String fieldDescription = 'description';
  static const String fieldDueDate = 'dueDate';
  static const String fieldPriority = 'priority';
  static const String fieldIsCompleted = 'isCompleted';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// A task is overdue when it is not completed and its due day has passed.
  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today);
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      userId: map[fieldUserId] as String? ?? '',
      title: map[fieldTitle] as String? ?? '',
      description: map[fieldDescription] as String? ?? '',
      dueDate: _toDateTime(map[fieldDueDate]),
      priority: TaskPriority.fromName(map[fieldPriority] as String?),
      isCompleted: map[fieldIsCompleted] as bool? ?? false,
      createdAt: _toDateTime(map[fieldCreatedAt]),
      updatedAt: _toDateTime(map[fieldUpdatedAt]),
    );
  }

  factory TaskModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TaskModel.fromMap(doc.data() ?? <String, dynamic>{}, doc.id);
  }

  /// The document id is not stored inside the document itself.
  Map<String, dynamic> toMap() {
    return {
      fieldUserId: userId,
      fieldTitle: title,
      fieldDescription: description,
      fieldDueDate: Timestamp.fromDate(dueDate),
      fieldPriority: priority.name,
      fieldIsCompleted: isCompleted,
      fieldCreatedAt: Timestamp.fromDate(createdAt),
      fieldUpdatedAt: Timestamp.fromDate(updatedAt),
    };
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
