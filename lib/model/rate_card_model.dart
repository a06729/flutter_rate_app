import 'package:exchange_rate_app/model/rateInfo/rateInfo.dart';
import 'package:exchange_rate_app/services/exchange_rate_api.dart';
// import 'package:flutter/material.dart';
// import '../common/currency_icons_icons.dart';
import 'package:logger/logger.dart';

class RateCardModel {
  String _rateAmout = '';
  // final List _cardInfoList = [];
  //환율정보 변수
  late RateInfo rateInfo;
  //환율 카드 기본 정보를 넣기 위한 변수
  //
  late List<Map<String, dynamic>> _rateCardInfoDefault;
  bool _lodding = false;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  RateCardModel() {
    rateInfo = RateInfo();
    _rateCardInfoDefault = rateInfo.rateCardInfo;
  }

  get rateAmout => _rateAmout;

  get rateCardInfoDefault => _rateCardInfoDefault;

  // get cardInfoList => _cardInfoList;

  get lodding => _lodding;

  void apiLoding() {
    if (_lodding == true) {
      _lodding = false;
    } else {
      _lodding = true;
    }
  }

  Future rateApi(List<Map<String, dynamic>> rateCardInfo, String amount,
      String countryCode) async {
    var rateData = await ExchangeRateApi()
        .getRateApi(baseCode: countryCode, amount: amount);
    logger.d('countryCode:$countryCode');

    var rates = rateData["rate_data"]["rates"];

    var data = [..._rateCardInfoDefault];

    for (int i = 0; i < data.length; i++) {
      var currencyRate = rates[data[i]['code']];
      logger.d('countryCode:$currencyRate');
      _rateAmout =
          (double.parse(amount) * currencyRate).toStringAsFixed(2).toString();
      data[i]['rateAmout'] = _rateAmout;
    }

    _rateCardInfoDefault = data;
  }
}
