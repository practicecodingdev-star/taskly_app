import 'package:flutter/material.dart';
import 'package:taskly_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter("hive_boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
