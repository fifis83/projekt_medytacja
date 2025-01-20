import 'package:flutter/material.dart';
import 'package:projekt_medytacja/data_utils.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  int _i = 1;

  String calcAvgTime() {
    int secSum = 0;
    for (var i = 0; i < DataUtils.curSesh.length; i++) {
      int minutes = int.parse(DataUtils.curSesh[i].substring(0, 2));
      int seconds = int.parse(DataUtils.curSesh[i].substring(3));
      secSum = seconds + (minutes * 60);
    }
    int avgSecs = (secSum / DataUtils.curSesh.length).floor();
    return '${(avgSecs / 60).floor().toString().padLeft(2, '0')}:${(avgSecs % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Results"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [Icon(Icons.timer_outlined), Text("Average time:")]),
            Text(calcAvgTime()),
          ],
        ),
        Column(
          children:
              DataUtils.curSesh.map((time) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Round ${_i++}"), Text(time)],
                );
              }).toList(),
        ),
      ],
    );
  }
}
