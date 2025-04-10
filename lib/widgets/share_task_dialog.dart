import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';

class ShareTaskDialog extends StatefulWidget {
  final String taskId;

  const ShareTaskDialog({required this.taskId, super.key});

  @override
  _ShareTaskDialogState createState() => _ShareTaskDialogState();
}

class _ShareTaskDialogState extends State<ShareTaskDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', hintText: 'Enter recipient email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final email = _emailController.text.trim();
              try {
                final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
                await taskViewModel.shareTask(widget.taskId, email);
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Task shared with $email'), duration: const Duration(seconds: 2)));
                  Navigator.pop(context);
                  await Share.share(
                    'Check out this task I shared with you!.Please login with this $email if account exist or create a new one.',
                    subject: 'Task Shared via Task App',
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Task shared with $email'), duration: const Duration(seconds: 2)));
                  Navigator.pop(context);
                }
              }
            }
          },
          child: const Text('Share'),
        ),
      ],
    );
  }
}
