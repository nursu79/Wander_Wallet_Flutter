import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final double? width;
  const RectangularButton({super.key, required this.onPressed, required this.text, this.isLoading = false, this.color, this.textColor, this.width});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: (color != null) ? WidgetStateProperty.all(color) : WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
        foregroundColor: (textColor != null) ? WidgetStateProperty.all(textColor) : WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 64.0),
        ),
        minimumSize: WidgetStateProperty.all<Size>(
          Size(width ?? 100, 48.0),
        ),
      ),
      child: isLoading 
        ? const CircularProgressIndicator() 
        : Text(
            text,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
    );
  }
}