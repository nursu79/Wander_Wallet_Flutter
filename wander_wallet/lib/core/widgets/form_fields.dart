import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? placeHolder;
  final bool isPassword;
  final String? errorMessage;
  const OutlinedTextField({super.key, required this.label, required this.controller, this.placeHolder, this.errorMessage, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline
              ),
            ),
            hintText: placeHolder,
            errorText: errorMessage,
          ),
        )
      ],
    );
  }
}