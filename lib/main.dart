import 'package:flutter/material.dart';

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
          seedColor: Color.fromARGB(255, 15, 48, 115),
          secondary: Colors.amber,
        ),
        useMaterial3: true,
      ),

      home: Options(),
    );
  }
}

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  int breathingSpeed = 1;
  bool music = false;
  bool voice = false;
  int breathsBeforeRetention = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Opcje",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 40,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Music switch
          Row(
            children: [
              Text("Muzyka"),
              Switch(
                value: music,
                onChanged: (val) {
                  setState(() {
                    music = val;
                  });
                },
              ),
            ],
          ),

          // Voice switch
          Row(
            children: [
              Text("Głos Wim Hofa "),
              Switch(
                value: voice,
                onChanged: (val) {
                  setState(() {
                    voice = val;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
