import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/common_text_field.dart';
import 'package:to_do/widgets/date_picker_widget.dart';

class EditTaskView extends StatefulWidget {
  final TaskModel task;

  const EditTaskView({required this.task, super.key});

  @override
  _EditTaskViewState createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _selectedDate = widget.task.dueDate;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CommonTextField(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              CommonTextField(controller: _descriptionController, labelText: 'Description', maxLines: 3),
              const SizedBox(height: 16),
              DatePickerWidget(initialDate: _selectedDate, onDateSelected: (date) => _selectedDate = date),
              CheckboxListTile(
                title: const Text('Completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final updatedTask = widget.task.copyWith(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: _selectedDate,
                        isCompleted: _isCompleted,
                      );
                      await taskViewModel.updateTask(updatedTask);
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
                      }
                    }
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
