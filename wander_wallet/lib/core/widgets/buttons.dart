import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final double? width;
  final bool? fillWidth;
  const RectangularButton({super.key, required this.onPressed, required this.text, this.isLoading = false, this.color, this.textColor, this.width, this.fillWidth});

  @override
  Widget build(BuildContext context) {
    return (fillWidth == true) ? Expanded(
      flex: 1,
      child: ElevatedButton(
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
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          ),
          minimumSize: WidgetStateProperty.all<Size>(
            Size(width ?? 100, 48.0),
          ),
        ),
        child: isLoading 
          ? CircularProgressIndicator(color: (textColor != null) ? textColor : Theme.of(context).colorScheme.onPrimary, strokeWidth: 12,) 
          : Text(
              text,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              ),
            ),
      )
    ) : ElevatedButton(
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
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          ),
          minimumSize: WidgetStateProperty.all<Size>(
            Size(width ?? 100, 48.0),
          ),
        ),
        child: isLoading 
          ? CircularProgressIndicator(color: (textColor != null) ? textColor : Theme.of(context).colorScheme.onPrimary, strokeWidth: 12,) 
          : Text(
              text,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              ),
            ),
      );
  }
}