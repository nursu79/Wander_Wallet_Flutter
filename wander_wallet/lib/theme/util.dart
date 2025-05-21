import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    displayLarge: bodyTextTheme.displayLarge,
    displayMedium: bodyTextTheme.displayMedium,
    displaySmall: bodyTextTheme.displaySmall,
    titleLarge: bodyTextTheme.titleLarge,
    titleMedium: bodyTextTheme.titleMedium,
    titleSmall: TextStyle(
      fontFamily: bodyTextTheme.bodyLarge?.fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w900
    ),
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
