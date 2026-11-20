import 'package:flutter/material.dart';

class AppTheme {
  // Palette Obsidian & Copper
  static const Color obsidian = Color(0xFF171717);
  static const Color copper = Color(0xFFB87333);
  static const Color burntOrange = Color(0xFFD96C3B);
  static const Color sand = Color(0xFFE8DCC8);
  static const Color warmGrey = Color(0xFF77716B);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidian,
      primaryColor: copper,
      colorScheme: const ColorScheme.dark(
        primary: copper,
        secondary: burntOrange,
        surface: Color(0xFF222222),
        onSurface: sand,
        onPrimary: obsidian,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: obsidian,
        foregroundColor: sand,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF222222),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF38312B),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF222222),
        hintStyle: const TextStyle(color: warmGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: copper),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: copper,
          foregroundColor: obsidian,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: sand,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: sand,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: sand),
        bodyMedium: TextStyle(color: warmGrey),
      ),
    );
  }
}
