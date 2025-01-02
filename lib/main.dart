import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hexagon/hexagon.dart';

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
      return (int.parse(values[0]),int.parse(values[1]),bool.parse(values[2]),bool.parse(values[3]),bool.parse(values[4]),bool.parse(values[5])); 
    } catch (e) {
      return (30,1,false,false,false,false);
    }
  }
}

class Options extends StatefulWidget {
  const Options({super.key,});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  DataUtils storage=DataUtils();
  int  breathsBeforeRetention = 30;
  bool breathingMusic = false;
  bool retentionMusic = false;
  bool voice = false;
  bool pingAndGong = false;
  int  _speed = 1;

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

  Future<File> _saveData(){
    setState((){});
    return storage.writeData(breathsBeforeRetention, _speed, breathingMusic, retentionMusic, voice, pingAndGong);
  }

  Widget customRadioButton(String text, int speed) {
    return FilledButton(
      onPressed: () {
        setState(() {
          _speed = speed;
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
                Expanded(
                  child: customRadioButton("Wolno",1),
                ),
                Expanded(
                  child: customRadioButton("Średnio",2), 
                ),
                Expanded(
                  child: customRadioButton("Szybko", 3),
                ),
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
                  });
                },
              ),
            ],
          ),
          
          // temp save button
          Row(
            children: [
            FloatingActionButton(onPressed: _saveData,child:Text("save")),
            FloatingActionButton(onPressed: (){
              _saveData();
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>const Breathing()),
              );},
              child:Text("start"))
            ],
          ),

        ],
      ),
    );
  }
}

class Breathing extends StatefulWidget {
  const Breathing({super.key});

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing> 
with SingleTickerProviderStateMixin {
  
  DataUtils storage = DataUtils();

  int  breathsBeforeRetention = 30;
  bool breathingMusic = false;
  bool retentionMusic = false;
  bool voice = false;
  bool pingAndGong = false;
  int  _speed = 1;

  late AnimationController _animationController;
  var scaleAnimation;

  @override void initState() {
      super.initState();
      
      _animationController = AnimationController(
        duration:Duration(milliseconds: 1300),
        //reverseDuration: Duration(seconds: 2),
        vsync: this, 
      )..addListener((){
        setState(() {});
        });
      
      _animationController.forward();
      _animationController.addStatusListener((status){
        if(status == AnimationStatus.completed){
          if(breathsBeforeRetention!=0){
            setState(() {
            breathsBeforeRetention--;
            });
            _animationController.reverse();
          } else {
            Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>const Options())
              //MaterialPageRoute(builder: (context)=>const Retention()),
            );
          }
        } else if(status == AnimationStatus.dismissed){
          _animationController.forward();
        }
      });

      scaleAnimation = new Tween<double>(begin:1,end:0.11
      ).animate(new CurvedAnimation(parent: _animationController, curve:Curves.easeInOutQuart));
      
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
    return Scaffold(
    appBar: ,
    body:Column(
    children: [
      ScaleTransition(
        scale: scaleAnimation,
        alignment: Alignment.center,
        child:
        HexagonWidget.pointy(
          width: 100, 
          color:Theme.of(context).colorScheme.onPrimaryContainer,
          child:ScaleTransition(
            scale: scaleAnimation ,
            alignment: Alignment.center,
            child:HexagonWidget.pointy(
              width: 95, 
              color:Theme.of(context).colorScheme.primary,
              child:ScaleTransition(
            scale: scaleAnimation,
            alignment: Alignment.center,
            child:HexagonWidget.pointy(
              width: 90, 
              color:Theme.of(context).colorScheme.primaryFixedDim,
              child:ScaleTransition(
            scale: scaleAnimation,
            alignment: Alignment.center,
            child:
            HexagonWidget.pointy(
              width: 85, 
              color:Theme.of(context).colorScheme.primaryContainer,
              child:Text(breathsBeforeRetention.toString(),style: TextStyle(color: Theme.of(context).colorScheme.primary,decoration: TextDecoration.none),),
        ),),
        ),),
      ),),
      ),),
    ]
    )
    ); 
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
