import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        )
            : const Text(
          'Save Note',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}