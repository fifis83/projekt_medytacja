import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:projekt_medytacja/app_bar_content.dart';
import 'package:projekt_medytacja/retention.dart';
import 'package:projekt_medytacja/data_utils.dart';

class Breathing extends StatefulWidget {
  const Breathing({super.key, required this.round});

  final int round;

  @override
  State<Breathing> createState() => _BreathingState();
}

AudioPlayer musicP = AudioPlayer();

class _BreathingState extends State<Breathing>
    with SingleTickerProviderStateMixin {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  late AudioPlayer voiceP = AudioPlayer();
  late AudioPlayer breathInP = AudioPlayer();
  late AudioPlayer breathOutP = AudioPlayer();
  late AudioPlayer pingP = AudioPlayer();

  int _curBreaths = 1;

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  late Color animColor;

  void _initAudio() async {
    if (DataUtils.breathingMusic) {
      musicP = AudioPlayer();
      musicP.setSourceAsset('music.mp3');
      musicP.setReleaseMode(ReleaseMode.loop);
    }

    if (DataUtils.voice) {
      voiceP = AudioPlayer();
      switch (DataUtils.speed) {
        case 1:
          voiceP.setSourceAsset('slow.mp3');
          break;
        case 2:
          voiceP.setSourceAsset('normal.mp3');
          break;
        case 3:
          voiceP.setSourceAsset('fast.mp3');
          break;
      }
      voiceP.setReleaseMode(ReleaseMode.release);
    }

    if (DataUtils.breathing) {
      breathInP = AudioPlayer();
      breathOutP = AudioPlayer();

      breathInP.setSourceAsset('breath in.mp3');
      breathOutP.setSourceAsset('breath out.mp3');

      breathInP.setReleaseMode(ReleaseMode.stop);
      breathOutP.setReleaseMode(ReleaseMode.stop);
    }

    if (DataUtils.pingAndGong) {
      pingP = AudioPlayer();
      pingP.setSourceAsset('ping.mp3');
      pingP.setReleaseMode(ReleaseMode.release);
    }

    WidgetsBinding.instance.addPostFrameCallback((time) async {
      // start audio 10ms after first frame bc it doesn't work right away
      await Future.delayed(Duration(milliseconds: 50));
      pingP.resume();
      breathInP.resume();
      voiceP.resume();
      musicP.resume();
    });
  }

  void _stopAudio() {
    voiceP.stop();
    pingP.stop();
    breathInP.stop();
    breathOutP.stop();
  }

  @override
  void initState() {
    super.initState();

    _initAudio();

    Duration breathDur = Duration();
    switch (DataUtils.speed) {
      case 1:
        breathDur = Duration(milliseconds: 3000);
        animColor = Color.fromARGB(255,20, 55, 69);
        break;
      case 2:
        breathDur = Duration(milliseconds: 2000);
        animColor = Color.fromARGB(255, 185, 61, 19);
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
          breathInP.stop();
          breathOutP.resume();
        } else {
          if (!DataUtils.retentionMusic) musicP.stop();
          _stopAudio();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Retention(round: widget.round),
            ),
          );
        }
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _curBreaths++;
        });
        _animationController.forward();
        breathOutP.stop();
        breathInP.resume();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appBarContent(widget.round, context),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          if (!DataUtils.retentionMusic) musicP.stop();
          _stopAudio();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Retention(round: widget.round),
            ),
          );
        },
        child:Theme(
    data:  ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255,10, 40, 50),
          brightness: Brightness.light
        )),
    child:  Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Take ${DataUtils.breathsBeforeRetention} deep breaths"),

            //TODO think about this
            Expanded(
              child: ScaleTransition(
                scale: scaleAnimation,
                alignment: Alignment.center,
                child: HexagonWidget.pointy(
                  cornerRadius: 10.0,
                  width: 200,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    alignment: Alignment.center,
                    child: HexagonWidget.pointy(
                      cornerRadius: 10.0,
                      width: 190,
                      color: Theme.of(context).colorScheme.primary,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        alignment: Alignment.center,
                        child: HexagonWidget.pointy(
                          cornerRadius: 10.0,
                          width: 180,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            alignment: Alignment.center,
                            child: HexagonWidget.pointy(
                              cornerRadius: 10.0,
                              width: 170,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
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
            ),
            Text("Tap twice to go into retention"),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    musicP.stop();
    _animationController.dispose();
    //voiceP.stop();
    voiceP.dispose();
    breathInP.dispose();
    breathOutP.dispose();
    pingP.dispose();
    super.dispose();
  }
}
