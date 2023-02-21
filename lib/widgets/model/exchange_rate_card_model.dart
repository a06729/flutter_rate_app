import 'package:flutter/material.dart';

class ExchangeRateCardModel {
  List<Map<String, dynamic>> rateModels;

  ExchangeRateCardModel()
      : rateModels = [
          {
            'code': 'USD',
            'currencyName': '달러',
            'iconData': Icons.attach_money,
          },
          {
            'code': 'EUR',
            'currencyName': '유로',
            'iconData': Icons.euro_symbol,
          },
          {
            'code': 'JPY',
            'currencyName': '엔화',
            'iconData': Icons.currency_yen,
          },
        ];
}
