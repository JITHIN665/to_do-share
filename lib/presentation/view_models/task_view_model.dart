import 'package:flutter/foundation.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/data/repositories/task_repository.dart';

class TaskViewModel with ChangeNotifier {
  final TaskRepository _repository;
  String _userId;

  TaskViewModel(this._repository, this._userId);

  String get userId => _userId;
  List<TaskModel> _tasks = [];
  List<TaskModel> _sharedTasks = [];

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get sharedTasks => _sharedTasks;

  void updateUserId(String newUserId) {
    _userId = newUserId;
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([loadTasks(), loadSharedTasks()]);
  }

  Future<void> loadTasks() async {
    try {
      _tasks = await _repository.getTasks(_userId).first;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      rethrow;
    }
  }

  Future<void> loadSharedTasks() async {
    try {
      _sharedTasks = await _repository.getSharedTasks(_userId).first;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading shared tasks: $e');
      rethrow;
    }
  }


  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _repository.updateTask(task);
    await Future.wait([loadTasks(), loadSharedTasks()]);
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);
    await Future.wait([loadTasks(), loadSharedTasks()]);
  }

  Future<void> shareTask(String taskId, String userId) async {
    await _repository.shareTask(taskId, userId);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
  try {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _repository.updateTask(updatedTask);
    
    // Immediately update local state
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
    }
    
    final sharedTaskIndex = _sharedTasks.indexWhere((t) => t.id == task.id);
    if (sharedTaskIndex != -1) {
      _sharedTasks[sharedTaskIndex] = updatedTask;
    }
    
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}
}