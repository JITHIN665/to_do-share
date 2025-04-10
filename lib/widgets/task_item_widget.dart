import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/share_task_dialog.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isOwner;

  const TaskItemWidget({required this.task, this.onTap, this.onEdit, this.onDelete, this.isOwner = true, super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: task.isCompleted, onChanged: (value) => taskViewModel.toggleTaskCompletion(task)),
        title: Text(task.title, maxLines: 2, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMd().add_jm().format(task.dueDate), maxLines: 2),
            if (task.description.isNotEmpty) Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOwner) ...[
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => showDialog(context: context, builder: (_) => ShareTaskDialog(taskId: task.id)),
              ),
              if (onEdit != null) IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              if (onDelete != null) IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
            ],
          ],
        ),
      ),
    );
  }
}
