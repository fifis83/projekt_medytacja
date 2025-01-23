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
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255,20, 55, 69),
          brightness: Brightness.light
        ),
        useMaterial3: true,
      ),

      home: Options(),
    );
  }
}
