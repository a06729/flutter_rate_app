import 'package:exchange_rate_app/model/rate_card_model.dart';
import 'package:flutter/material.dart';

class RateCardController extends ChangeNotifier {
  late final RateCardModel _model;

  RateCardController() {
    _model = RateCardModel();
  }

  String get rateAmout => _model.rateAmout;

  List<Map<String, dynamic>> get rateCardInfo => _model.rateCardInfoDefault;

  // List<Map<String, dynamic>> get cardInfoList => _model.cardInfoList;

  bool get lodding => _model.lodding;

  void update() {
    notifyListeners();
  }

  Future<void> rateApi(List<Map<String, dynamic>> rateCardInfo, String amount,
      String countryCode) async {
    if (amount.isNotEmpty) {
      _model.apiLoding();
      update();
      await _model.rateApi(rateCardInfo, amount, countryCode).then((value) {
        _model.apiLoding();
        update();
      });
    }
  }
}
