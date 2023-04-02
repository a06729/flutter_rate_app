import 'package:shared_preferences/shared_preferences.dart';

class TheamModel {
  late bool _darkMode;
  // TheamModel._init();
  TheamModel() {
    _darkMode = true;
  }

  get darkMode => _darkMode;

  Future<void> changeMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (_darkMode) {
      _darkMode = false;
      await prefs.setBool('darkMode', false);
    } else {
      _darkMode = true;
      await prefs.setBool('darkMode', true);
    }
  }

  //초기 실행시 테마 설정값을 가져와서 업데이트하는 함수
  Future<void> initMode() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? darkModeValue = prefs.getBool('darkMode');
    if (darkModeValue == null) {
      _darkMode = true;
      await prefs.setBool('darkMode', darkMode);
    } else {
      _darkMode = darkModeValue;
    }
  }
}
