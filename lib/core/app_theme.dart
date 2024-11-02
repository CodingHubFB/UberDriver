import 'package:flutter/material.dart';

final appTheme = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: Colors.black.withOpacity(0.2),
    selectionHandleColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  colorScheme: const ColorScheme.light(
    primaryContainer: Colors.black,
    secondaryContainer: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 20),
    titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    headlineSmall: TextStyle(fontSize: 17),
    displaySmall: TextStyle(fontSize: 11, color: Colors.black38),
  ),
  fontFamily: "Ubuntu",
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200.withOpacity(0.8),
    border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)),
    labelStyle: const TextStyle(fontSize: 14),
    floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
    prefixStyle: const TextStyle(fontSize: 15, color: Colors.blue),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: const WidgetStatePropertyAll(Color(0xFF2D2E2F)),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
    )
  ),
);