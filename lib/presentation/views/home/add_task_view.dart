import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/common_text_field.dart';
import 'package:to_do/widgets/date_picker_widget.dart';

class AddTaskView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    DateTime? selectedDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
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
              DatePickerWidget(onDateSelected: (date) => selectedDate = date, initialDate: DateTime.now().add(const Duration(days: 1))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && selectedDate != null) {
                    try {
                      final task = TaskModel(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: selectedDate!,
                        creatorId: taskViewModel.userId,
                      );
                      await taskViewModel.addTask(task);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add task: $e')));
                    }
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
