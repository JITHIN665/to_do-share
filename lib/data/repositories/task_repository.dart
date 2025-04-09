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
        .map((snapshot) => snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList());
  }

  Stream<List<TaskModel>> getSharedTasks(String userId) {
    return _firestore
        .collection(AppConstants.tasksCollection)
        .where('sharedWith', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList());
  }

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection(AppConstants.tasksCollection).doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final docRef = _firestore.collection(AppConstants.tasksCollection).doc(task.id);

      // First check if document exists
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Task document not found');
      }

      // Then perform update
      await docRef.update(task.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to update task: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection(AppConstants.tasksCollection).doc(taskId).delete();
  }

  Future<void> shareTask(String taskId, String userId) async {
    await _firestore.collection(AppConstants.tasksCollection).doc(taskId).update({
      'sharedWith': FieldValue.arrayUnion([userId]),
    });
  }
}
