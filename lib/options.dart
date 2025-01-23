import 'package:flutter/material.dart';
import 'package:projekt_medytacja/data_utils.dart';
export 'package:projekt_medytacja/data_utils.dart';
import 'package:projekt_medytacja/breathing.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';

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
  bool? _breathing = false;
  bool? _recoveryMusic = false;

  void getUserPreferences() async {
    if (await prefs.getInt('bBR') != null) {
      _breathsBeforeRetention = await prefs.getInt('bBR');
      _speed = await prefs.getInt('s');
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
  }

  @override
  void initState() {
    super.initState();
    _initAudio();
    getUserPreferences();
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
              style: TextStyle(color: customNavy, fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            //TODO:breathsBeforeRetention slider
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
                ElevatedButton( 
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
      ),
    );
  }
}
