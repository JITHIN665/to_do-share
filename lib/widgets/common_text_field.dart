import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;

  const CommonTextField({
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}