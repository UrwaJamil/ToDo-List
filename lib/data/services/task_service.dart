import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../app/constants/app_strings.dart';
import '../models/task_model.dart';
import 'auth_service.dart';

/// Data layer for tasks. Every task lives under users/{uid}/tasks/{taskId},
/// so a user can only ever reach their own tasks.
class TaskService extends GetxService {
  TaskService(this._authService);

  static const String tasksCollection = 'tasks';

  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw Exception(AppStrings.errorNotLoggedIn);
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tasksRef => _firestore
      .collection(AuthService.usersCollection)
      .doc(_uid)
      .collection(tasksCollection);

  /// Real-time stream of the current user's tasks.
  Stream<List<TaskModel>> streamTasks() {
    return _tasksRef.snapshots().map(
      (snapshot) => snapshot.docs.map(TaskModel.fromFirestore).toList(),
    );
  }

  /// Returns the saved task, including its new Firestore ID.
  Future<TaskModel> createTask(TaskModel task) async {
    final doc = _tasksRef.doc();
    final now = DateTime.now();
    final created = task.copyWith(
      id: doc.id,
      userId: _uid,
      createdAt: now,
      updatedAt: now,
    );
    await doc.set(created.toMap());
    return created;
  }

  Future<void> updateTask(TaskModel task) {
    return _tasksRef
        .doc(task.id)
        .update(task.copyWith(updatedAt: DateTime.now()).toMap());
  }

  Future<void> setCompleted(String taskId, bool isCompleted) {
    return _tasksRef.doc(taskId).update({
      TaskModel.fieldIsCompleted: isCompleted,
      TaskModel.fieldUpdatedAt: Timestamp.now(),
    });
  }

  Future<void> deleteTask(String taskId) => _tasksRef.doc(taskId).delete();
}
