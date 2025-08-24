import 'package:firebase_browser/features/core/themes/app_theme.dart';
import 'package:firebase_browser/features/db_management/blocs/db_cubit/db_cubit.dart';
import 'package:firebase_browser/features/db_management/screens/db_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const FirebaseBrowserApp());
}

class FirebaseBrowserApp extends StatelessWidget {
  const FirebaseBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => DatabaseCubit())],
      child: MaterialApp(
        title: 'Firebase Browser',
        theme: FirebaseAppTheme().light,
        darkTheme: FirebaseAppTheme().dark,
        themeMode: ThemeMode.system,
        home: DbSelectionView(),
      ),
    );
  }
}
