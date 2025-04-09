import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/task_item_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authViewModel.signOut();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
          bottom: const TabBar(tabs: [Tab(text: 'My Tasks'), Tab(text: 'Shared With Me')]),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask), child: const Icon(Icons.add)),
        body: TabBarView(
          children: [_TaskList(tasks: taskViewModel.tasks, isOwner: true), _TaskList(tasks: taskViewModel.sharedTasks, isOwner: false)],
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final bool isOwner;

  const _TaskList({required this.tasks, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks found'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItemWidget(
          task: task,
          onTap: () => Navigator.pushNamed(context, AppRoutes.taskDetail, arguments: task),
          onEdit: isOwner ? () => Navigator.pushNamed(context, AppRoutes.editTask, arguments: task) : null,
          onDelete: isOwner ? () => _deleteTask(context, task) : null,
        );
      },
    );
  }

  Future<void> _deleteTask(BuildContext context, TaskModel task) async {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    try {
      await taskViewModel.deleteTask(task.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete task: $e')));
    }
  }
}
