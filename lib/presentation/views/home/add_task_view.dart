import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final taskViewModel = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              TextFormField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description'), maxLines: 3),
              ListTile(
                title: Text(_dueDate == null ? 'Select Due Date' : 'Due Date: ${DateFormat.yMd().format(_dueDate!)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final task = TaskModel(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: _dueDate ?? DateTime.now().add(Duration(days: 1)),
                        creatorId: authViewModel.user!.id,
                      );
                      await taskViewModel.addTask(task);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add task: $e')));
                    }
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
