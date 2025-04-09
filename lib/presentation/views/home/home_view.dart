import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/task_item_widget.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskViewModel.loadTasks();
      taskViewModel.loadSharedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Tasks'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authViewModel.signOut();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Tasks'),
              Tab(text: 'Shared With Me'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(taskViewModel.tasks, true),
            _buildTaskList(taskViewModel.sharedTasks, false),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks, bool isOwner) {
    if (tasks.isEmpty) {
      return Center(child: Text('No tasks found'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItemWidget(
          task: task,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.taskDetail,
            arguments: task,
          ),
          onEdit: isOwner
              ? () => Navigator.pushNamed(
                    context,
                    AppRoutes.editTask,
                    arguments: task,
                  )
              : null,
          onDelete: isOwner
              ? () => _deleteTask(context, task)
              : null,
        );
      },
    );
  }

  Future<void> _deleteTask(BuildContext context, TaskModel task) async {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    try {
      await taskViewModel.deleteTask(task.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }
}