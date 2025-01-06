import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:async';

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
  //TODO change this to use shared_preferences
  static String curSesh = "";

  Future<File> get _seshFile async {
    if(curSesh == "") {
      curSesh=DateTime.now().toString();
    }
    return File('/home/filip/dev/$curSesh.txt');
  }

  Future<File> saveRound(int round, String time) async {
    final file = await _seshFile;
    return file.writeAsString('$round=$time');
  }

  Future<List<(int,String)>> getSeshData() async{
    List<(int,String)> lines;
    try {
          
    } catch (e) {
      return(lines);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    //final path = await _localPath;
    //return File('$path/data.txt');
    //TODO fix the path
    return File('/home/filip/dev/data.txt');
  }

  Future<File> writeData(
    int bBR,
    int speed,
    bool bM,
    bool rM,
    bool v,
    bool pAG,
  ) async {
    final file = await _localFile;
    return file.writeAsString('$bBR,$speed,$bM,$rM,$v,$pAG,');
  }

  Future<(int, int, bool, bool, bool, bool)> readData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final values = contents.split(',');
      return (
        int.parse(values[0]),
        int.parse(values[1]),
        bool.parse(values[2]),
        bool.parse(values[3]),
        bool.parse(values[4]),
        bool.parse(values[5]),
      );
    } catch (e) {
      return (30, 1, false, false, false, false);
    }
  }

}

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  DataUtils storage = DataUtils();
  int breathsBeforeRetention = 30;
  bool breathingMusic = false;
  bool retentionMusic = false;
  bool voice = false;
  bool pingAndGong = false;
  int _speed = 1;

  final int _round = 1;

  @override
  void initState() {
    super.initState();
    storage.readData().then((v) {
      setState(() {
        breathsBeforeRetention = v.$1;
        _speed = v.$2;
        breathingMusic = v.$3;
        retentionMusic = v.$4;
        voice = v.$5;
        pingAndGong = v.$6;
      });
    });
  }

  Future<File> _saveUserPreferences() {
    setState(() {});
    return storage.writeData(
      breathsBeforeRetention,
      _speed,
      breathingMusic,
      retentionMusic,
      voice,
      pingAndGong,
    );
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
                value: breathingMusic,
                onChanged: (val) {
                  setState(() {
                    breathingMusic = val;
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
                value: retentionMusic,
                onChanged: (val) {
                  setState(() {
                    retentionMusic = val;
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
                value: voice,
                onChanged: (val) {
                  setState(() {
                    voice = val;
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
                value: pingAndGong,
                onChanged: (val) {
                  setState(() {
                    pingAndGong = val;
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
  DataUtils storage = DataUtils();

  int breathsBeforeRetention = 30;
  bool breathingMusic = false;
  bool retentionMusic = false;
  bool voice = false;
  bool pingAndGong = false;
  int _speed = 1;

  int _curBreaths = 0;

  late AnimationController _animationController;
  var scaleAnimation;

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
        if (breathsBeforeRetention != _curBreaths) {
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

    scaleAnimation = Tween<double>(begin: 1, end: 0.11).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );

    storage.readData().then((v) {
      setState(() {
        breathsBeforeRetention = v.$1;
        _speed = v.$2;
        breathingMusic = v.$3;
        retentionMusic = v.$4;
        voice = v.$5;
        pingAndGong = v.$6;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO add double tap to go to retention
    return Scaffold(
      //TODO add appbar
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
          Text("Take $breathsBeforeRetention deep breaths"),
          ScaleTransition(
            scale: scaleAnimation,
            alignment: Alignment.center,
            child: HexagonWidget.pointy(
              width: 100,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              child: ScaleTransition(
                scale: scaleAnimation,
                alignment: Alignment.center,
                child: HexagonWidget.pointy(
                  width: 95,
                  color: Theme.of(context).colorScheme.primary,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    alignment: Alignment.center,
                    child: HexagonWidget.pointy(
                      width: 90,
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        alignment: Alignment.center,
                        child: HexagonWidget.pointy(
                          width: 85,
                          color: Theme.of(context).colorScheme.primaryContainer,
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
          ),
          Text("Tap twice to go into retention"),
        ],
      ),
    ));
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
      body: GestureDetector(
      behavior: HitTestBehavior.opaque,
        onDoubleTap: () {

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
            //Container(),
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
          if(_stopwatch.elapsed.inSeconds >= 20){
            _elapsedTime =Duration(seconds: 15); 
          }
          }
        );
      };
      
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
