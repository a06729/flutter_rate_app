import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TheamModel {
  late bool _darkMode;
  TheamModel() {
    _darkMode = false;
  }

  get darkMode => _darkMode;

  Future<void> changeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final switchMode = prefs.getBool('darkMode');
    logger.d("스위칭 다크모드:${switchMode}");
    if (switchMode != null) {
      if (switchMode == true) {
        _darkMode = false;
        await prefs.setBool('darkMode', false);
      } else {
        _darkMode = true;
        await prefs.setBool('darkMode', true);
      }
    } else {
      await prefs.setBool('darkMode', false);
      _darkMode = false;
    }
  }

  //초기 실행시 테마 설정값을 가져와서 업데이트하는 함수
  Future<void> initMode() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? darkModeValue = prefs.getBool('darkMode');
    if (darkModeValue != null) {
      _darkMode = darkModeValue;
    } else {
      _darkMode = false;
    }
  }
}
