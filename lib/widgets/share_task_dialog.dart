import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/common_text_field.dart';

class ShareTaskDialog extends StatefulWidget {
  final String taskId;

  const ShareTaskDialog({required this.taskId, Key? key}) : super(key: key);

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
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return AlertDialog(
      title: const Text('Share Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(
              controller: _emailController,
              labelText: 'User Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Enter valid email' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await taskViewModel.shareTask(
                      widget.taskId,
                      _emailController.text,
                    );
                    Navigator.pop(context);
                    
                    // Share via other apps
                    await Share.share(
                      'Check out this task I shared with you!',
                      subject: 'Task Shared via Task App',
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to share task: $e')),
                    );
                  }
                }
              },
              child: const Text('Share via Email'),
            ),
            TextButton(
              onPressed: () async {
                await Share.share(
                  'Check out this task I want to share with you!',
                  subject: 'Task Shared via Task App',
                );
              },
              child: const Text('Share via Other Apps'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}