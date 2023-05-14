import 'package:exchange_rate_app/model/login_page_model.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  late final LoginPageModel _model;
  bool get lodding => _model.loding;
  LoginController() {
    _model = LoginPageModel();
  }
  void update() {
    notifyListeners();
  }

  //로그인 클릭시 로딩 화면 업데이트
  void loginLodding(bool val) {
    _model.loding = val;
    update();
  }
}
