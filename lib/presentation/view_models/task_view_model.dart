import 'package:flutter/foundation.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/data/repositories/task_repository.dart';

class TaskViewModel with ChangeNotifier {
  final TaskRepository _repository;
  String _userId;
  String _userEmail;
  List<TaskModel> _tasks = [];
  List<TaskModel> _sharedTasks = [];
  bool _isLoading = false;
  String? _error;

  TaskViewModel(this._repository, this._userId, this._userEmail);

  String get userId => _userId;
  String get userEmail => _userEmail;
  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get sharedTasks => _sharedTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateUserInfo(String newUserId, String newUserEmail) {
    _userId = newUserId;
    _userEmail = newUserEmail;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _tasks = await _repository.getTasks(_userId).first;
    } catch (e) {
      _error = 'Failed to load tasks';
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSharedTasks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _sharedTasks = await _repository.getSharedTasks(_userEmail).first;
    } catch (e) {
      _error = 'Failed to load shared tasks';
      debugPrint('Error loading shared tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.addTask(task);
      _tasks.insert(0, task);
    } catch (e) {
      _error = 'Failed to add task';
      debugPrint('Error adding task: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.updateTask(task);
      
      final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = task;
      }
      
      final sharedTaskIndex = _sharedTasks.indexWhere((t) => t.id == task.id);
      if (sharedTaskIndex != -1) {
        _sharedTasks[sharedTaskIndex] = task;
      }
    } catch (e) {
      _error = 'Failed to update task';
      debugPrint('Error updating task: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _sharedTasks.removeWhere((task) => task.id == taskId);
    } catch (e) {
      _error = 'Failed to delete task';
      debugPrint('Error deleting task: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      rethrow;
    }
  }

  Future<void> shareTask(String taskId, String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.shareTask(taskId, email);
      await loadTasks();
    } catch (e) {
      _error = 'Failed to share task';
      debugPrint('Error sharing task: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}