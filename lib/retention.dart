import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:async';
import 'package:projekt_medytacja/app_bar_content.dart';
import 'package:projekt_medytacja/data_utils.dart';
import 'package:projekt_medytacja/recovery.dart';
import 'package:projekt_medytacja/breathing.dart' show musicP;

class Retention extends StatefulWidget {
  const Retention({super.key, required this.round});

  final int round;

  @override
  State<Retention> createState() => _RetentionState();
}

class _RetentionState extends State<Retention> {
  final Stopwatch _stopwatch = Stopwatch()..start();
  late Timer timer;

  late AudioPlayer pingP = AudioPlayer();
  late AudioPlayer voiceP = AudioPlayer();

  void _initAudio() async {
    if(DataUtils.retentionMusic && !DataUtils.breathingMusic){
      musicP = AudioPlayer();
      musicP.setSourceAsset('music.mp3');
      musicP.setReleaseMode(ReleaseMode.release);
    }

    if (DataUtils.pingAndGong) {
      pingP = AudioPlayer();
      pingP.setReleaseMode(ReleaseMode.release);
      pingP.setSourceAsset('ping.mp3');
    }

    if (DataUtils.voice) {
      voiceP = AudioPlayer();
      voiceP.setReleaseMode(ReleaseMode.release);
      voiceP.setSourceAsset('retention.mp3');
    }

    WidgetsBinding.instance.addPostFrameCallback((time) async {
      // start audio 10ms after first frame bc it doesn't work right away
      await Future.delayed(Duration(milliseconds: 50));
      pingP.resume();
      voiceP.resume();
      musicP.resume();
    });
  }

  void _stopAudio(){
    pingP.stop();
    voiceP.stop();
    musicP.stop();
  }

  @override
  void initState() {
    super.initState();
    _initAudio();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    voiceP.dispose();
    pingP.dispose();
    musicP.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: appBarContent(
          widget.round,
          context,
          '${_stopwatch.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_stopwatch.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}',
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          if (_stopwatch.elapsed < Duration(seconds: 5)) return;
          _stopAudio();
          _stopwatch.stop();
          DataUtils.finishRound(
            '${_stopwatch.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_stopwatch.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}',
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Recovery(round: widget.round),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Let go and hold',
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Container(),
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
                      Text(
                        widget.round > 1
                            ? 'Previous round\n${DataUtils.getLastRound()}'
                            : '',
                      ),
                    ],
                  ),
                ),
                Text(
                  _stopwatch.elapsed > Duration(seconds: 5)
                      ? "Tap twice to go into recovery breath"
                      : "",
                ),
              ],
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
