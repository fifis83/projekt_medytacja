import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

class DataUtils {
  static List<String> curSesh = [];

  void saveCurSesh() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    prefs.setStringList(DateTime.now().toString(), curSesh);
  }

  String getLastRound() {
    return curSesh.last;
  }

  static void finishRound(String time) {
    curSesh.add(time);
  }

  //Future<List<String>> getSesh(String)
}

Widget appBarContent(int round, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,   
    children: [
      // for correct spacing
      Text("Finish",style:TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),

      Text('Round $round'),

      CupertinoButton(
      
        child: Text("Finish"),
        onPressed: () {
          //TODO go to results screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Options()),
            (Route<dynamic> route) => false,
          );
        },
      ),
    ],
  );
}

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

  final int _round = 1;

  void getUserPreferences() async {
    if (await prefs.getInt('bBR') != null) {
      _breathsBeforeRetention = await prefs.getInt('bBR');
      _speed = await prefs.getInt('s');
      _breathingMusic = await prefs.getBool('bM');
      _retentionMusic = await prefs.getBool('rM');
      _voice = await prefs.getBool('v');
      _pingAndGong = await prefs.getBool('pAG');
    }
    ;
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
                Expanded(child: customRadioButton("Wolno", 1)),
                Expanded(child: customRadioButton("Średnio", 2)),
                Expanded(child: customRadioButton("Szybko", 3)),
              ],
            ),
          ),
          // Music switch
          Row(
            children: [
              Text("Muzyka podczas oddychania"),
              Switch(
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
              Text("Muzyka podczas wstrzymywania oddechu"),
              Switch(
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
              Text("Głos Wim Hofa "),
              Switch(
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
              Text("Gong"),
              Switch(
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

          // start sesh button
          Row(
            children: [
              FloatingActionButton(
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

class Breathing extends StatefulWidget {
  const Breathing({super.key, required this.round});

  final int round;

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing>
    with SingleTickerProviderStateMixin {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  int? _breathsBeforeRetention = 30;
  bool? _breathingMusic = false;
  bool? _retentionMusic = false;
  bool? _voice = false;
  bool? _pingAndGong = false;
  int? _speed = 1;

  int _curBreaths = 0;

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  
  void getUserPreferences() async {
    if (await prefs.getInt('bBR') != null) {
      _breathsBeforeRetention = await prefs.getInt('bBR');
      _speed = await prefs.getInt('s');
      _breathingMusic = await prefs.getBool('bM');
      _retentionMusic = await prefs.getBool('rM');
      _voice = await prefs.getBool('v');
      _pingAndGong = await prefs.getBool('pAG');
    }
    
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1300),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_breathsBeforeRetention != _curBreaths) {
          setState(() {
            _curBreaths++;
          });
          _animationController.reverse();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Retention(round: widget.round),
            ),
          );
        }
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    scaleAnimation = Tween<double>(begin: 1, end: 0.01).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );

    setState(() {
      getUserPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false ,title: appBarContent(widget.round, context)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Retention(round: widget.round),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Take $_breathsBeforeRetention deep breaths"),

            //TODO think about this
            Expanded(
            child:ScaleTransition(
              scale: scaleAnimation,
              alignment: Alignment.center,
              child: HexagonWidget.pointy(
                width: 200,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  alignment: Alignment.center,
                  child: HexagonWidget.pointy(
                    width: 190,
                    color: Theme.of(context).colorScheme.primary,
                    child: ScaleTransition(
                      scale: scaleAnimation,
                      alignment: Alignment.center,
                      child: HexagonWidget.pointy(
                        width: 180,
                        color: Theme.of(context).colorScheme.primaryFixedDim,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          alignment: Alignment.center,
                          child: HexagonWidget.pointy(
                            width: 170,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              _curBreaths.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),),
            Text("Tap twice to go into retention"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class Retention extends StatefulWidget {
  const Retention({super.key, required this.round});

  final int round;

  @override
  State<Retention> createState() => _RetentionState();
}

class _RetentionState extends State<Retention> {
  final Stopwatch _stopwatch = Stopwatch()..start();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(titleSpacing: 0, automaticallyImplyLeading: false, title: appBarContent(widget.round, context)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          _stopwatch.stop();
          DataUtils.finishRound(_stopwatch.toString());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Recovery(round: widget.round),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Let go and hold',
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Column(
              children: [
                HexagonWidget.pointy(
                  width: 200,
                  cornerRadius: 10,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Round ${widget.round}"),
                      Text(
                        '${_stopwatch.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_stopwatch.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.none,
                          fontSize: 42,
                        ),
                      ),
                    ],
                  ),
                ),
                Text("Tap twice to go into recovery breath"),
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}

class Recovery extends StatefulWidget {
  const Recovery({super.key, required this.round});

  final int round;

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final Stopwatch _stopwatch = Stopwatch()..start();
  late Timer timer;

  Duration _elapsedTime = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_stopwatch.elapsed.inSeconds >= 5) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed - Duration(seconds: 5);
          if (_stopwatch.elapsed.inSeconds >= 20) {
            _elapsedTime = Duration(seconds: 15);
          }
        });
      }
      ;

      if (_stopwatch.elapsed.inSeconds == 22) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Breathing(round: widget.round + 1),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false ,title: appBarContent(widget.round, context)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Take a deep breath in and hold',
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Column(
            children: [
              HexagonWidget.pointy(
                width: 200,
                cornerRadius: 10,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '${_elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.none,
                    fontSize: 42,
                  ),
                ),
              ),
            ],
          ),
          //Container(),
        ],
      ),
    );
  }
}
