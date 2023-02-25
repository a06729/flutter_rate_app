class TheamModel {
  bool _darkMode = true;

  get darkMode => _darkMode;

  void changeMode() {
    if (_darkMode) {
      _darkMode = false;
    } else {
      _darkMode = true;
    }
  }
}
