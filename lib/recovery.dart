import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:async';
import 'package:projekt_medytacja/app_bar_content.dart';
import 'package:projekt_medytacja/breathing.dart';
import 'package:projekt_medytacja/data_utils.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key, required this.round});

  final int round;

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final Stopwatch _stopwatch = Stopwatch()..start();
  late Timer timer;
  
  late AudioPlayer _musicP = AudioPlayer();
  late AudioPlayer _voiceP = AudioPlayer();

  Duration _elapsedTime = Duration(seconds: 0);

  void _initAudio() async {
    if (DataUtils.recoveryMusic) {
      _musicP = AudioPlayer();
      _musicP.setReleaseMode(ReleaseMode.release);
      _musicP.setSourceAsset('recovery.mp3');
    }

    if (DataUtils.voice) {
      _voiceP = AudioPlayer();
      _voiceP.setReleaseMode(ReleaseMode.release);
      _voiceP.setSourceAsset('recovery voice.mp3');
    }

    WidgetsBinding.instance.addPostFrameCallback((time) async {
      // start audio 10ms after first frame bc it doesn't work right away
      await Future.delayed(Duration(milliseconds: 50));
      _musicP.resume();
      _voiceP.resume();
    });

  }

  @override
  void initState() {
    super.initState();
    _initAudio();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_stopwatch.elapsed.inSeconds >= 5) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed - Duration(seconds: 5);
          if (_stopwatch.elapsed.inSeconds >= 20) {
            _elapsedTime = Duration(seconds: 15);
          }
        });
      }

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
    _voiceP.dispose();
    _musicP.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appBarContent(widget.round, context),
      ),
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
