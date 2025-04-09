import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/task_item_widget.dart';

class SharedTasksView extends StatelessWidget {
  const SharedTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await taskViewModel.loadSharedTasks();
      },
      child: taskViewModel.sharedTasks.isEmpty
          ? const Center(child: Text('No shared tasks available'))
          : ListView.builder(
              itemCount: taskViewModel.sharedTasks.length,
              itemBuilder: (context, index) {
                final task = taskViewModel.sharedTasks[index];
                return TaskItemWidget(
                  task: task,
                  isOwner: false,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.taskDetail,
                    arguments: task,
                  ),
                );
              },
            ),
    );
  }
}