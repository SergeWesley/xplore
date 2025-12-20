import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0D0D1A),
      cardTheme: const CardThemeData(color: Color(0xFF1A1A2E), elevation: 4),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D1A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
