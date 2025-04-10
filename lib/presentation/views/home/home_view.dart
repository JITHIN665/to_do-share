import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/task_item_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

      if (authViewModel.isAuthenticated) {
        taskViewModel.loadTasks();
        taskViewModel.loadSharedTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('My Tasks'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                await authViewModel.signOut();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
          bottom: const TabBar(tabs: [Tab(text: 'My Tasks'), Tab(text: 'Shared With Me')]),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask), child: const Icon(Icons.add)),
        body: TabBarView(children: [taskList(taskViewModel.tasks, true), sharedTaskList(taskViewModel.sharedTasks, true)]),
      ),
    );
  }

  Widget taskList(List<TaskModel> tasks, bool isOwner) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    if (taskViewModel.isLoading && tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskViewModel.error != null && tasks.isEmpty) {
      return Center(child: Text(taskViewModel.error!));
    }

    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await taskViewModel.loadTasks();
        await taskViewModel.loadSharedTasks();
      },
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskItemWidget(
            task: task,
            isOwner: isOwner,
            onTap: () => Navigator.pushNamed(context, AppRoutes.taskDetail, arguments: task),
            onEdit: isOwner ? () => Navigator.pushNamed(context, AppRoutes.editTask, arguments: task) : null,
            onDelete: isOwner ? () => deleteTask(context, task) : null,
          );
        },
      ),
    );
  }

  Widget sharedTaskList(List<TaskModel> sharedTasks, bool isOwner) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    if (taskViewModel.isLoading && sharedTasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskViewModel.error != null && sharedTasks.isEmpty) {
      return Center(child: Text(taskViewModel.error!));
    }

    if (sharedTasks.isEmpty) {
      return const Center(child: Text('No shared tasks available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await taskViewModel.loadSharedTasks();
      },
      child: ListView.builder(
        itemCount: sharedTasks.length,
        itemBuilder: (context, index) {
          final task = sharedTasks[index];
          return TaskItemWidget(
            task: task,
            isOwner: isOwner,
            onTap: () => Navigator.pushNamed(context, AppRoutes.taskDetail, arguments: task),
            onEdit: isOwner ? () => Navigator.pushNamed(context, AppRoutes.editTask, arguments: task) : null,
            onDelete: isOwner ? () => deleteTask(context, task) : null,
          );
        },
      ),
    );
  }

  Future<void> deleteTask(BuildContext context, TaskModel task) async {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    try {
      await taskViewModel.deleteTask(task.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete task: $e')));
    }
  }
}
