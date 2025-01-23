import 'package:shared_preferences/shared_preferences.dart';
export 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DataUtils {
  static List<String> curSesh = [];
  static int speed = 1;
  static int breathsBeforeRetention = 30;
  static bool breathingMusic = false;
  static bool retentionMusic = false;
  static bool voice = false;
  static bool pingAndGong = false;
  static bool breathing = false;
  static bool recoveryMusic = false;
  void saveCurSesh() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    prefs.setStringList(DateTime.now().toString(), curSesh);
    curSesh.clear();
  }
  
  static String getLastRound() {
    return curSesh.last;
  }

  static void finishRound(String time) {
    curSesh.add(time);
  }
}

final Color customGrey = Color.fromARGB(255,241,247,247);
final Color customNavy = Color.fromARGB(255, 20, 55, 69);
