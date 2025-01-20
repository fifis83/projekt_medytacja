import 'package:flutter/material.dart';
import 'package:projekt_medytacja/data_utils.dart';
export 'package:projekt_medytacja/data_utils.dart';
import 'package:projekt_medytacja/breathing.dart';
import 'package:flutter/cupertino.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  int? _breathsBeforeRetention = 30;
  bool? _breathingMusic = false;
  bool? _retentionMusic = false;
  bool? _voice = false;
  bool? _pingAndGong = false;
  int? _speed = 1;
  bool? _breathing = false;

  void getUserPreferences() async {
    if (await prefs.getInt('bBR') != null) {
      _breathsBeforeRetention = await prefs.getInt('bBR');
      _speed = await prefs.getInt('s');
      _breathingMusic = await prefs.getBool('bM');
      _retentionMusic = await prefs.getBool('rM');
      _voice = await prefs.getBool('v');
      _pingAndGong = await prefs.getBool('pAG');
      _breathing = await prefs.getBool('b');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getUserPreferences();
    });
  }

  void _saveUserPreferences() async {
    setState(() {});

    await prefs.setInt('bBR', _breathsBeforeRetention!);
    await prefs.setInt('s', _speed!);
    await prefs.setBool('bM', _breathingMusic!);
    await prefs.setBool('rM', _retentionMusic!);
    await prefs.setBool('v', _voice!);
    await prefs.setBool('pAG', _pingAndGong!);
    await prefs.setBool('b', _breathing!);
  }

  Widget customRadioButton(String text, int speed) {
    return FilledButton(
      onPressed: () {
        setState(() {
          _speed = speed;
          _saveUserPreferences();
        });
      },
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor:
            (_speed == speed)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
      ),
      child: Text(
        text,
        style: TextStyle(
          color:
              (_speed == speed)
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

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
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: customRadioButton("Slow", 1)),
                Expanded(child: customRadioButton("Medium", 2)),
                Expanded(child: customRadioButton("Fast", 3)),
              ],
            ),
          ),

          // Music switch
          Row(
            children: [
              Text("Breathing phase music"),
              CupertinoSwitch(
                applyTheme: true,
                value: _breathingMusic!,
                onChanged: (val) {
                  setState(() {
                    _breathingMusic = val;
                    _saveUserPreferences();
                  });
                },
              ),
            ],
          ),

          Row(
            children: [
              Text("Retention phase music"),
              CupertinoSwitch(
                applyTheme: true,
                value: _retentionMusic!,
                onChanged: (val) {
                  setState(() {
                    _retentionMusic = val;
                    _saveUserPreferences();
                  });
                },
              ),
            ],
          ),

          // Voice switch
          Row(
            children: [
              Text("Wim's voice"),
              CupertinoSwitch(
                applyTheme: true,
                value: _voice!,
                onChanged: (val) {
                  setState(() {
                    _voice = val;
                    _saveUserPreferences();
                  });
                },
              ),
            ],
          ),

          // Ping and Gong at the end of session switch
          Row(
            children: [
              Text("Ping and gong"),
              CupertinoSwitch(
                applyTheme: true,
                value: _pingAndGong!,
                onChanged: (val) {
                  setState(() {
                    _pingAndGong = val;
                    _saveUserPreferences();
                  });
                },
              ),
            ],
          ),
          
          // Breathing sound switch 
          Row(
            children: [
              Text("Breathing"),
              CupertinoSwitch(
                applyTheme: true,
                value: _breathing!,
                onChanged: (val) {
                  setState(() {
                    _breathing = val;
                    _saveUserPreferences();
                  });
                },
              ),
            ],
          ),                                                                      

          // start sesh button
          Row(
            children: [
              CupertinoButton(
                onPressed: () {
                  _saveUserPreferences();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Breathing(round: 1),
                    ),
                  );
                },
                child: Text("start"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
