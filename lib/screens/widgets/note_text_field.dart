import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isTitle;
  final FormFieldValidator<String>? validator;

  const NoteTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isTitle = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          style: TextStyle(
            fontSize: isTitle ? 20 : 16,
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
          ),
          maxLines: isTitle ? 1 : null,
          keyboardType: TextInputType.multiline,
          validator: validator,
        ),
        if (isTitle) const Divider(height: 1, thickness: 1),
        if (isTitle) const SizedBox(height: 16),
      ],
    );
  }
}