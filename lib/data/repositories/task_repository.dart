import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/core/constants/app_constants.dart';
import 'package:to_do/data/models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getTasks(String userId) {
    return _firestore
        .collection(AppConstants.tasksCollection)
        .where('creatorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<TaskModel>> getSharedTasks(String email) {
    return _firestore
        .collection(AppConstants.tasksCollection)
        .where('sharedEmails', arrayContains: email)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> addTask(TaskModel task) async {
    await _firestore
        .collection(AppConstants.tasksCollection)
        .doc(task.id)
        .set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _firestore
        .collection(AppConstants.tasksCollection)
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore
        .collection(AppConstants.tasksCollection)
        .doc(taskId)
        .delete();
  }

  Future<void> shareTask(String taskId, String email) async {
    await _firestore
        .collection(AppConstants.tasksCollection)
        .doc(taskId)
        .update({
      'sharedEmails': FieldValue.arrayUnion([email]),
    });
  }
}