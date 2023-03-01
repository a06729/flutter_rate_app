import 'package:exchange_rate_app/common/currency_icons_icons.dart';
import 'package:flutter/material.dart';

class RateInfo {
  //국가코드,화폐이름,화폐심볼을 저장하는 변수
  final List<Map<String, dynamic>> _rateCardInfo = [
    {
      'code': 'USD',
      'currencyName': '달러',
      'currencySymbol': '\$',
      'rateAmout': ''
    },
    {
      'code': 'EUR',
      'currencyName': '유로',
      'currencySymbol': '€',
      'rateAmout': ''
    },
    {
      'code': 'KRW',
      'currencyName': '원',
      'currencySymbol': '₩',
      'rateAmout': ''
    },
    {
      'code': 'CNY',
      'currencyName': '위안화',
      'currencySymbol': '¥',
      'rateAmout': ''
    },
    {
      'code': 'JPY',
      'currencyName': '엔화',
      'currencySymbol': '¥',
      'rateAmout': ''
    },
    {
      'code': 'HKD',
      'currencyName': '홍콩 달러',
      'currencySymbol': '\$',
      'rateAmout': ''
    },
    {
      'code': 'THB',
      'currencyName': '바트',
      'currencySymbol': '฿',
      'rateAmout': ''
    },
    {
      'code': 'GBP',
      'currencyName': '파운드',
      'currencySymbol': '£',
      'rateAmout': ''
    },
    {
      'code': 'RUB',
      'currencyName': '루블',
      'currencySymbol': '',
      'rateAmout': ''
    },
    {
      'code': 'INR',
      'currencyName': '루피',
      'currencySymbol': '₹',
      'rateAmout': ''
    },
    {
      'code': 'PHP',
      'currencyName': '페소',
      'currencySymbol': '₱',
      'rateAmout': ''
    },
    {
      'code': 'TWD',
      'currencyName': '타이완 달러',
      'currencySymbol': '\$',
      'rateAmout': ''
    },
    {
      'code': 'VND',
      'currencyName': '동',
      'currencySymbol': '₫',
      'rateAmout': ''
    },
  ];
  //국가 코드별로 아이콘 정보를 정리해놓은 변수
  final Map<String, dynamic> currencyIconMap = {
    'USD': {
      'iconData': Icons.attach_money,
    },
    'EUR': {
      'iconData': Icons.euro_symbol,
    },
    'KRW': {
      'iconData': CurrencyIcons.wonSymbol,
    },
    'CNY': {
      'iconData': CurrencyIcons.taiwanSymbol,
    },
    'JPY': {
      'iconData': Icons.currency_yen,
    },
    'HKD': {
      'iconData': Icons.attach_money,
    },
    'THB': {
      'iconData': CurrencyIcons.baht,
    },
    'GBP': {
      'iconData': Icons.currency_pound,
    },
    'RUB': {
      'iconData': Icons.currency_ruble_outlined,
    },
    'INR': {
      'iconData': Icons.currency_rupee_outlined,
    },
    'PHP': {
      'iconData': CurrencyIcons.peso_com,
    },
    'TWD': {
      'iconData': CurrencyIcons.taiwanSymbol,
    },
    'VND': {
      'iconData': CurrencyIcons.dongSymbol,
    }
  };

  get rateCardInfo {
    return _rateCardInfo;
  }

  IconData currencyIcon(key) {
    return currencyIconMap[key]['iconData'];
  }
}
