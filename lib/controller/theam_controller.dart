import 'package:exchange_rate_app/model/theam_model.dart';
import 'package:flutter/material.dart';

class TheamController extends ChangeNotifier {
  late final TheamModel _model;

  TheamController() {
    _model = TheamModel();
  }

  get darkMod => _model.darkMode;

  void dartMode() {
    _model.changeMode();
    update();
  }

  void update() {
    notifyListeners();
  }
}
