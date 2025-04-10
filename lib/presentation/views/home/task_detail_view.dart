import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/views/home/edit_task_view.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModel task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final isCreator = authViewModel.user?.id == task.creatorId;

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black)),
            const SizedBox(height: 8),
            Text('Due: ${DateFormat.yMMMd().format(task.dueDate)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black)),
            const SizedBox(height: 8),
            Text(
              'Status: ${task.isCompleted ? 'Completed' : 'Pending'}',
              style: TextStyle(fontSize: 1, fontWeight: FontWeight.w700, color: task.isCompleted ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 16),
            Text('Description:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black)),
            Text(task.description),
            if (!isCreator)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Shared by: ${task.creatorId}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey)),
              ),
          ],
        ),
      ),
      floatingActionButton:
          isCreator
              ? FloatingActionButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditTaskView(task: task))),
                child: const Icon(Icons.edit),
              )
              : null,
    );
  }
}
