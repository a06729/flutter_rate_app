import 'package:exchange_rate_app/model/keybord_model.dart';
import 'package:flutter/material.dart';

class KeybordAmountController extends ChangeNotifier {
  late KeybordModel _model;

  KeybordAmountController() {
    _model = KeybordModel();
  }
  //환율을 변환하기위한 금액 변수
  String get amount => _model.amount;

  //입력칸에 적시한 글자를 표시하는 변수
  String get diplayValue => _model.displayValue;

  String get rateAmout => _model.rateAmout;
  //국가 코드
  String get countryCode => _model.countryCode;

  void update() {
    notifyListeners();
  }

  void countryCodeUpdate(String code) {
    _model.countryCodeUpdate(code);
    update();
  }

  void onKeyTap(String val) {
    _model.onKeyTap(val);
    update();
  }

  // Future rateApi(baseCode) async {
  //   await _model.rateApi(baseCode);
  //   update();
  // }
}
