import 'package:exchange_rate_app/common/currency_icons_icons.dart';
import 'package:flutter/material.dart';

class RateInfo {
  final List<Map<String, dynamic>> _rateCardInfo = [
    {
      'code': 'USD',
      'currencyName': '달러',
      'iconData': Icons.attach_money,
      'currencySymbol': '\$',
      'rateAmout': ''
    },
    {
      'code': 'EUR',
      'currencyName': '유로',
      'currencySymbol': '€',
      'iconData': Icons.euro_symbol,
      'rateAmout': ''
    },
    {
      'code': 'KRW',
      'currencyName': '원',
      'currencySymbol': '₩',
      'iconData': CurrencyIcons.wonSymbol,
      'rateAmout': ''
    },
    {
      'code': 'CNY',
      'currencyName': '위안화',
      'currencySymbol': '¥',
      'iconData': CurrencyIcons.taiwanSymbol,
      'rateAmout': ''
    },
    {
      'code': 'JPY',
      'currencyName': '엔화',
      'currencySymbol': '¥',
      'iconData': Icons.currency_yen,
      'rateAmout': ''
    },
    {
      'code': 'HKD',
      'currencyName': '홍콩 달러',
      'currencySymbol': '\$',
      'iconData': Icons.attach_money,
      'rateAmout': ''
    },
    {
      'code': 'THB',
      'currencyName': '바트',
      'currencySymbol': '฿',
      'iconData': CurrencyIcons.baht,
      'rateAmout': ''
    },
    {
      'code': 'GBP',
      'currencyName': '파운드',
      'currencySymbol': '£',
      'iconData': Icons.currency_pound,
      'rateAmout': ''
    },
    {
      'code': 'RUB',
      'currencyName': '루블',
      'currencySymbol': '',
      'iconData': Icons.currency_ruble_outlined,
      'rateAmout': ''
    },
    {
      'code': 'INR',
      'currencyName': '루피',
      'currencySymbol': '₹',
      'iconData': Icons.currency_rupee_outlined,
      'rateAmout': ''
    },
    {
      'code': 'PHP',
      'currencyName': '페소',
      'currencySymbol': '₱',
      'iconData': CurrencyIcons.peso_com,
      'rateAmout': ''
    },
    {
      'code': 'TWD',
      'currencyName': '타이완 달러',
      'currencySymbol': '\$',
      'iconData': CurrencyIcons.taiwanSymbol,
      'rateAmout': ''
    },
    {
      'code': 'VND',
      'currencyName': '동',
      'currencySymbol': '₫',
      'iconData': CurrencyIcons.dongSymbol,
      'rateAmout': ''
    },
  ];

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
