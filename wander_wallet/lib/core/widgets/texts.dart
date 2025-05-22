import 'package:flutter/material.dart';

class SmallErrorText extends StatelessWidget {
  final String text;

  const SmallErrorText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
        color: Theme.of(context).colorScheme.error
      ),
    );
  }
}