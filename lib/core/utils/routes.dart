import 'package:flutter/material.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/views/auth/login_view.dart';
import 'package:to_do/presentation/views/auth/register_view.dart';
import 'package:to_do/presentation/views/home/add_task_view.dart';
import 'package:to_do/presentation/views/home/edit_task_view.dart';
import 'package:to_do/presentation/views/home/home_view.dart';
import 'package:to_do/presentation/views/home/shared_tasks_view.dart';
import 'package:to_do/presentation/views/home/task_detail_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String taskDetail = '/task-detail';
  static const String sharedTasks = '/shared-tasks';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case addTask:
        return MaterialPageRoute(builder: (_) => AddTaskView());
      case editTask:
        final task = settings.arguments as TaskModel?;
        if (task == null) {
          return _errorRoute('Task argument is required for EditTaskView');
        }
        return MaterialPageRoute(
          builder: (_) => EditTaskView(task: task),
        );
      case taskDetail:
        final task = settings.arguments as TaskModel?;
        if (task == null) {
          return _errorRoute('Task argument is required for TaskDetailView');
        }
        return MaterialPageRoute(
          builder: (_) => TaskDetailView(task: task),
        );
      case sharedTasks:
        return MaterialPageRoute(builder: (_) => SharedTasksView());
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}