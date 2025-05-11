import 'package:flutter/material.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/theme/app_theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes APp',
      theme: AppThemeData.lightThemeData,
      home: HomeScreen(),
    );
  }
}

