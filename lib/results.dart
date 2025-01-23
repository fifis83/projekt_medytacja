import 'package:flutter/material.dart';
import 'package:projekt_medytacja/data_utils.dart';
import 'package:projekt_medytacja/text_style.dart';
import 'package:audioplayers/audioplayers.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late AudioPlayer _voiceP = AudioPlayer();
  late AudioPlayer _gongP = AudioPlayer();

  String calcAvgTime() {
    int secSum = 0;
    for (var i = 0; i < DataUtils.curSesh.length; i++) {
      int minutes = int.parse(DataUtils.curSesh[i].substring(0, 2));
      int seconds = int.parse(DataUtils.curSesh[i].substring(3));
      secSum += seconds + (minutes * 60);
    }
    int avgSecs = (secSum / DataUtils.curSesh.length).floor();
    return '${(avgSecs / 60).floor().toString().padLeft(2, '0')}:${(avgSecs % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    () async {
      if (DataUtils.voice) {
        _voiceP = AudioPlayer();
        _voiceP.setSourceAsset('result voice.mp3');
        _voiceP.setReleaseMode(ReleaseMode.release);
      }

      if (DataUtils.pingAndGong) {
        _gongP = AudioPlayer();
        _gongP.setSourceAsset('gong.mp3');
        _gongP.setReleaseMode(ReleaseMode.release);
      }
    };
    WidgetsBinding.instance.addPostFrameCallback((time) async {
      // start audio 10ms after first frame bc it doesn't work right away
      await Future.delayed(Duration(milliseconds: 50));
      _voiceP.resume();
      _gongP.resume();
    });
    super.initState();
  }

  @override
  void dispose() {
    _voiceP.dispose();
    _gongP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Well done!",
            style: navyText 
            //TextStyle(
            //  //color: Color.fromARGB(255, 20, , 80),
            //  //decoration: TextDecoration.none,
            //  //fontSize: 17,
            //),
          ),
          Text(
            "Take a breath and relax, regain your normal breathing speed.\nHere are your results.",
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 20),
                      Text(" Average time:", style: navyText),
                    ],
                  ),
                  Text(calcAvgTime(), style: navyText),
                ],
              ),
            ),
          ),
          Column(
            children:
                DataUtils.curSesh.map((time) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black26)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Round ${DataUtils.curSesh.indexOf(time) + 1}",
                            style: navyText,
                          ),
                          Text(time, style: navyText),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),

          //ElevatedButton(onPressed: onPressed, child: Text("Save"))
        ],
      ),
    );
  }
}
