import 'package:firebase_browser/features/core/themes/app_theme.dart';
import 'package:firebase_browser/features/db_selection/screens/db_selection_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FirebaseBrowserApp());
}

class FirebaseBrowserApp extends StatelessWidget {
  const FirebaseBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Browser',
      theme: FirebaseAppTheme().light,
      darkTheme: FirebaseAppTheme().dark,
      themeMode: ThemeMode.system,
      home: DbSelectionView(),
    );
  }
}
