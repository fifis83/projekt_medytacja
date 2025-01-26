import 'package:flutter/material.dart';
import 'package:projekt_medytacja/data_utils.dart';
export 'package:projekt_medytacja/data_utils.dart';
import 'package:projekt_medytacja/breathing.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hexagon/hexagon.dart';
import 'package:projekt_medytacja/text_style.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> with SingleTickerProviderStateMixin {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  int? _breathsBeforeRetention = 30;
  bool? _breathingMusic = false;
  bool? _retentionMusic = false;
  bool? _voice = false;
  bool? _pingAndGong = false;
  int? _speed = 1;
  bool? _breathing = false;
  bool? _recoveryMusic = false;

  int _curBreaths = 1;

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  late Color animColor;

  void _getUserPreferences() async {
    if (await prefs.getInt('bBR') != null) {
      _speed = await prefs.getInt('s');
      _breathsBeforeRetention = await prefs.getInt('bBR');
      _breathingMusic = await prefs.getBool('bM');
      _retentionMusic = await prefs.getBool('rM');
      _voice = await prefs.getBool('v');
      _pingAndGong = await prefs.getBool('pAG');
      _recoveryMusic = await prefs.getBool('rM');
      _breathing = await prefs.getBool('b').whenComplete(() {
        setState(() {});
      });
    }
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
    await prefs.setBool('rM', _recoveryMusic!);

    DataUtils.speed = _speed!;
    DataUtils.breathsBeforeRetention = _breathsBeforeRetention!;
    DataUtils.breathingMusic = _breathingMusic!;
    DataUtils.retentionMusic = _retentionMusic!;
    DataUtils.voice = _voice!;
    DataUtils.pingAndGong = _pingAndGong!;
    DataUtils.breathing = _breathing!;
  }

  void _initAudio() async {
    //load every sound
    AudioPlayer player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.release);
    player.setSourceAsset('fast.mp3');
    player.setSourceAsset('normal.mp3');
    player.setSourceAsset('slow.mp3');
    player.setSourceAsset('ping.mp3');
    player.setSourceAsset('gong.mp3');
    player.setSourceAsset('music.mp3');
    player.setSourceAsset('recovery voice.mp3');
    player.setSourceAsset('recovery.mp3');
    player.setSourceAsset('result voice.mp3');
    player.setSourceAsset('retention.mp3');
  }

  @override
  void initState() {
    super.initState();
    _initAudio();
    _getUserPreferences();

    Duration breathDur = Duration();

    switch (_speed) {
      case 1:
        breathDur = Duration(milliseconds: 3000);
        animColor = Color.fromARGB(255, 20, 55, 69);
        break;
      case 2:
        breathDur = Duration(milliseconds: 2000);
        animColor = Color.fromARGB(255, 61, 185, 19);
        break;
      case 3:
        breathDur = Duration(milliseconds: 1300);
        animColor = Color.fromARGB(255, 23, 87, 101);
        break;
      default:
    }
    _animationController = AnimationController(duration: breathDur, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (DataUtils.breathsBeforeRetention != _curBreaths) {
          _animationController.reverse();
        } else {
          _curBreaths = 1;
        }
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _curBreaths++;
        });
        _animationController.forward();
      }
    });
    scaleAnimation = Tween<double>(begin: 0.01, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Widget customRadioButton(String text, int speed) {
    return FilledButton(
      onPressed: () {
        setState(() {
          _speed = speed;
          _saveUserPreferences();
          switch (speed) {
            case 1:
              _animationController.duration = Duration(milliseconds: 3000);
              animColor = Color.fromARGB(255, 20, 55, 69);
              break;
            case 2:
              _animationController.duration = Duration(milliseconds: 2000);
              animColor = Color.fromARGB(255, 61, 185, 19);
              break;
            case 3:
              _animationController.duration = Duration(milliseconds: 1300);
              animColor = Color.fromARGB(255, 23, 87, 101);
              break;
            default:
          }
        });
      },
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: (_speed == speed) ? customNavy : customGrey,
      ),
      child: Text(
        text,
        style: TextStyle(color: (_speed == speed) ? customGrey : customNavy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Guided breathing",
              style: TextStyle(
                color: customNavy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: EdgeInsets.all(40),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Theme(
                  data: ThemeData.from(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: animColor)),
                  child: Builder(
                    builder:(context) => ScaleTransition(
                      scale: scaleAnimation,
                        alignment: Alignment.center,
                        child: HexagonWidget.pointy(
                          cornerRadius: 10.0,
                          width: 100,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            alignment: Alignment.center,
                            child: HexagonWidget.pointy(
                              cornerRadius: 10.0,
                              width: 90,
                              color: Theme.of(context).colorScheme.primary,
                              child: ScaleTransition(
                                scale: scaleAnimation,
                                alignment: Alignment.center,
                                child: HexagonWidget.pointy(
                                  cornerRadius: 10.0,
                                  width: 80,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryFixedDim,
                                  child: ScaleTransition(
                                    scale: scaleAnimation,
                                    alignment: Alignment.center,
                                    child: HexagonWidget.pointy(
                                      cornerRadius: 10.0,
                                      width: 70,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                      child: Text(
                                        _curBreaths.toString(),
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
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
                  ),
                ),
              ],
            ),

            // breathing speed selector
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: customGrey,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Breaths before retention"),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_breathsBeforeRetention! > 5) _breathsBeforeRetention = _breathsBeforeRetention! - 5;
                      },
                      icon: Icon(Icons.remove_circle_outline,color:customNavy),
                    ),
                    Text("$_breathsBeforeRetention",style: navyText),
                    IconButton(
                      onPressed: () {
                        if (_breathsBeforeRetention! < 60) _breathsBeforeRetention = _breathsBeforeRetention! + 5;
                      },
                      icon: Icon(Icons.add_circle_outline,color: customNavy,),
                    ),
                  ],
                ),
              ],
            ),

            // Music switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recovery phase music"),
                CupertinoSwitch(
                  applyTheme: true,
                  value: _recoveryMusic!,
                  onChanged: (val) {
                    setState(() {
                      _recoveryMusic = val;
                      _saveUserPreferences();
                    });
                  },
                ),
              ],
            ),

            // Voice switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

            Spacer(),

            // start sesh button
            Row(
              children: [
              Expanded(child: 
              
                ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: customNavy,
                  foregroundColor: customGrey,
                ),
                  onPressed: () {
                    _saveUserPreferences();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Breathing(round: 1),
                      ),
                    );
                  },
                  child: Text("start"),
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
