import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:async';
import 'package:projekt_medytacja/app_bar_content.dart';
import 'package:projekt_medytacja/breathing.dart';

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
