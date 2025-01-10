import 'package:flutter/material.dart';
import 'package:projekt_medytacja/options.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wim Hof',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 50, 60),
          secondary: Colors.amber,
        ),
        useMaterial3: true,
      ),

      home: Options(),
    );
  }
}
//TODO create a text style
