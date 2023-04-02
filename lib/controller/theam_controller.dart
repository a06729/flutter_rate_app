import 'dart:ffi';

import 'package:exchange_rate_app/model/theam_model.dart';
import 'package:flutter/material.dart';

class TheamController extends ChangeNotifier {
  late final TheamModel _model;

  TheamController() {
    _model = TheamModel();
  }

  get darkMod => _model.darkMode;

  Future<void> dartMode() async {
    await _model.changeMode().then((value) => update());
  }

  //초기 실행시 테마 설정값을 가져와서 업데이트하는 함수
  Future<void> initMode() async {
    await _model.initMode();
    update();
  }

  void update() {
    notifyListeners();
  }
}
