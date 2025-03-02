import 'package:flutter/material.dart';
import 'package:trackit/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackit/theme/theme.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("Habit_DB");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: HomePage(),
    );
  }
}
