import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/models/task_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/widgets/common_text_field.dart';
import 'package:to_do/widgets/date_picker_widget.dart';

class EditTaskView extends StatelessWidget {
  final TaskModel task;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  EditTaskView({super.key, required this.task}) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    DateTime selectedDate = task.dueDate;
    bool isCompleted = task.isCompleted;

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
              DatePickerWidget(initialDate: task.dueDate, onDateSelected: (date) => selectedDate = date),
              CheckboxListTile(title: const Text('Completed'), value: isCompleted, onChanged: (value) => isCompleted = value ?? false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final updatedTask = task.copyWith(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: selectedDate,
                        isCompleted: isCompleted,
                      );
                      await taskViewModel.updateTask(updatedTask);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
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
