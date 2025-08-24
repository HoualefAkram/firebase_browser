import 'package:flutter/material.dart';
import 'package:firebase_browser/features/core/themes/colors.dart';

abstract class AppTheme {
  ThemeData get dark;
  ThemeData get light;
}

class FirebaseAppTheme implements AppTheme {
  static final ThemeColors _darkColors = FirebaseThemeColors.dark;
  static final ThemeColors _lightColors = FirebaseThemeColors.light;

  @override
  ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: _darkColors.scaffoldBackground,
    primaryColor: _darkColors.primary,
    colorScheme: ColorScheme.dark(
      primary: _darkColors.primary,
      secondary: _darkColors.secondary,
      surface: _darkColors.scaffoldBackground,
      onPrimary: _darkColors.textPrimary,
      onSecondary: _darkColors.textPrimary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _darkColors.textPrimary, fontSize: 26),
      bodyMedium: TextStyle(color: _darkColors.textSecondary),
    ),
    dividerColor: _darkColors.divider,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(_darkColors.primary),
        foregroundColor: WidgetStatePropertyAll(_darkColors.textPrimary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(18),
          ),
        ),
      ),
    ),
  );

  @override
  ThemeData get light => ThemeData(
    scaffoldBackgroundColor: _lightColors.scaffoldBackground,
    primaryColor: _lightColors.primary,
    colorScheme: ColorScheme.light(
      primary: _lightColors.primary,
      secondary: _lightColors.secondary,
      surface: _lightColors.scaffoldBackground,
      onPrimary: _lightColors.textPrimary,
      onSecondary: _lightColors.textPrimary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _lightColors.textPrimary),
      bodyMedium: TextStyle(color: _lightColors.textSecondary),
    ),
    dividerColor: _lightColors.divider,
  );
}
