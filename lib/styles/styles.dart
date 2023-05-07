import 'package:flutter/material.dart';

class CustomStyle {

  static MaterialColor pageSwatch = Colors.grey;

  static ColorScheme pageScheme = ColorScheme(
    primary: const Color(0xFF161616),
    secondary: const Color(0xFF262626),
    brightness: Brightness.dark,
    onPrimary: Colors.white,
    onSecondary: const Color(0xFFD9D9D9),
    error: Colors.red.shade800,
    onError: Colors.white70,
    background: Colors.red,
    onBackground: Colors.white70,
    surface: Colors.black38,
    onSurface: Colors.white70,
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    //foregroundColor: const Color(0xFFF5B342),
    foregroundColor: normalBlue,
    backgroundColor: pageScheme.primary,
    elevation: 10,
  );

  static TextSelectionThemeData pageTextSelectionTheme = TextSelectionThemeData(
    cursorColor: Colors.red,
    //selectionColor: const Color(0xFFF5B342),
    selectionColor: pageScheme.primary,
    selectionHandleColor: Colors.blue,
  );

  static TextStyle headers = TextStyle(
    fontSize: 20,
    color: pageScheme.onPrimary,
  );

  static TextStyle content = TextStyle(
    fontSize: 16,
    color: pageScheme.onSecondary,
  );

  static TextStyle textFieldEntry = TextStyle(
    fontSize: 20,
    fontFamily: 'JetBrainsMono',
    color: pageScheme.onSecondary,
  );

  static TextStyle disabledTextEntry = TextStyle(
    color: pageScheme.onSecondary,
    fontFamily: 'JetBrainsMono',
    fontSize: 20,
  );

  static Color disabledTextEntryBorderColor = const Color(0xFF4E4E4E);
  static Color normalBlue = const Color(0xFF40B4F2);

  static TextStyle cipherSelectionButton = TextStyle(
    fontSize: 20,
    color: pageScheme.onSecondary,
  );

  static TextStyle bigButton = TextStyle(
    fontSize: 20,
    color: pageScheme.onSecondary,
  );

  static TextStyle darkButton = TextStyle(
    fontSize: 20,
    color: pageScheme.onSecondary,
  );

  static TextStyle bodyLargeText = TextStyle(
    fontSize: 20,
    color: pageScheme.onSecondary,
  );

}