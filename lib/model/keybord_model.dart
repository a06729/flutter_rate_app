class KeybordModel {
  String _amount = '';
  String _displayValue = '';
  String _rateAmount = '';
  String _countryCode = 'KRW';

  String get amount => _amount;

  String get displayValue => _displayValue;
  String get rateAmout => _rateAmount;

  String get countryCode => _countryCode;

  set amount(val) {
    _amount = val;
  }

  set countryCode(code) {
    _countryCode = code;
  }

  set displayValue(val) {
    _displayValue = val;
  }

  set rateAmout(val) {
    _rateAmount = val;
  }

  void countryCodeUpdate(String code) {
    _countryCode = code;
  }

  void onKeyTap(String val) {
    // NumberFormat f = NumberFormat('###,###,###,###');

    if (val == '0' && amount.isEmpty) {
      return;
    } else if (val == '00' && amount.isEmpty) {
      return;
    }
    amount = val;
    if (amount.isNotEmpty) {
      displayValue = val;
    } else {
      displayValue = '';
    }
  }

  // rateApi(String baseCode) async {
  //   rateAmout =
  //       await ExchangeRateApi().getRateApi(baseCode: baseCode, amount: amount);
  // }
}
