import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/presentation/views/home/task_detail_view.dart';
import 'package:to_do/widgets/task_item_widget.dart';

class SharedTasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    if (taskViewModel.sharedTasks.isEmpty) {
      return Center(child: Text('No shared tasks available'));
    }

    return ListView.builder(
      itemCount: taskViewModel.sharedTasks.length,
      itemBuilder: (context, index) {
        final task = taskViewModel.sharedTasks[index];
        return TaskItemWidget(
          task: task,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailView(task: task),
            ),
          ),
        );
      },
    );
  }
}