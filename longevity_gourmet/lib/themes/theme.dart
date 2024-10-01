// lib/themes/theme.dart

import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.green,
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.orange,
  ),
  scaffoldBackgroundColor: const Color(0xFFF0F0F0),
  appBarTheme: const AppBarTheme(
    color: Color(0xFFF0F0F0),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.green,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.green,
  colorScheme: const ColorScheme.dark(
    primary: Colors.green,
    secondary: Colors.orange,
  ),
  scaffoldBackgroundColor: const Color(0xFF3E3E3E),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF3E3E3E),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.green,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
