import 'package:shared_preferences/shared_preferences.dart';
export 'package:shared_preferences/shared_preferences.dart';

class DataUtils {
  static List<String> curSesh = [];

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
