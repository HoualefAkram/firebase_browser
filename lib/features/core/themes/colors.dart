import 'package:flutter/material.dart';

class FirebaseThemeColors {
  static final ThemeColors dark = DarkThemeColors();
  static final ThemeColors light = LightThemeColors();
}

abstract class ThemeColors {
  Color get scaffoldBackground;
  Color get primary;
  Color get secondary;
  Color get accent;
  Color get textPrimary;
  Color get textSecondary;
  Color get divider;
}

class DarkThemeColors implements ThemeColors {
  @override
  Color get scaffoldBackground => const Color(0xFF121212); // Firebase dark bg

  @override
  Color get primary => const Color(0xFF039BE5); // Firebase blue

  @override
  Color get secondary => const Color(0xFFFFA000); // Firebase yellow

  @override
  Color get accent => const Color(0xFFFF6F00); // Firebase orange accent

  @override
  Color get textPrimary => Colors.white;

  @override
  Color get textSecondary => Colors.white70;

  @override
  Color get divider => Colors.white24;
}

class LightThemeColors implements ThemeColors {
  @override
  Color get scaffoldBackground => const Color(0xFFFFFFFF); // white bg

  @override
  Color get primary => const Color(0xFF039BE5); // Firebase blue

  @override
  Color get secondary => const Color(0xFFFFA000); // Firebase yellow

  @override
  Color get accent => const Color(0xFFFF6F00); // Firebase orange accent

  @override
  Color get textPrimary => Colors.black87;

  @override
  Color get textSecondary => Colors.black54;

  @override
  Color get divider => Colors.black12;
}
