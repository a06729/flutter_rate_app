import 'package:exchange_rate_app/hive/rate_model.dart';
import 'package:exchange_rate_app/model/rate_card_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class RateCardController extends ChangeNotifier {
  late final RateCardModel _model;
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  RateCardController() {
    _model = RateCardModel();
  }

  String get rateAmout => _model.rateAmout;

  List<Map<String, dynamic>> get rateCardInfo => _model.rateCardInfoDefault;

  bool get lodding => _model.lodding;

  void update() {
    notifyListeners();
  }

  //환율 카드 순서 변경하는 함수
  //순서 변경값을 hive db에 저장하는 함수
  Future<void> reorderRateCard(newIndex, item) async {
    await _model.reorderRateCard(newIndex, item);
    update();
  }

  //환율 카드에 기존에 환율 계산값 0으로 초기화 하는 기능
  Future<void> initRateCardData() async {
    final rateCardBox = await Hive.openBox<RateModel>('rateCardBox');
    final cardOrderValue = rateCardBox.get('cardOrder');
    if (cardOrderValue != null) {
      var initRateCardData = cardOrderValue.rates.map((item) {
        logger.d('initRateCardData:${item}');
        //기존 환율 정보를 0 초기화
        item['rateAmout'] = '0';
        return item;
      });
      _model.initRateCard(initRateCardData.toList());
      update();
    } else {
      _model.initRateCard(_model.rateInfo.rateCardInfo);
    }
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
