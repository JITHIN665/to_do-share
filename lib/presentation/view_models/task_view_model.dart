import 'package:flutter/foundation.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/data/repositories/task_repository.dart';

class TaskViewModel with ChangeNotifier {
  final TaskRepository _repository;
  final String userId;

  TaskViewModel(this._repository, this.userId);

  List<TaskModel> _tasks = [];
  List<TaskModel> _sharedTasks = [];

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get sharedTasks => _sharedTasks;

  Future<void> loadTasks() async {
    try {
      _repository.getTasks(userId).listen((tasks) {
        _tasks = tasks;
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadSharedTasks() async {
    try {
      _repository.getSharedTasks(userId).listen((tasks) {
        _sharedTasks = tasks;
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _repository.addTask(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _repository.updateTask(task);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareTask(String taskId, String userId) async {
    try {
      await _repository.shareTask(taskId, userId);
    } catch (e) {
      rethrow;
    }
  }
}
