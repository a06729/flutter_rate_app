import 'package:exchange_rate_app/model/payment_model.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:flutter/material.dart';

class PaymentController extends ChangeNotifier {
  late final PaymentModel _model;

  bool get paymentLodding => _model.paymentLodding;

  PaymentController() {
    _model = PaymentModel();
  }
  void update() {
    notifyListeners();
  }

  void setPaymentLodding(bool status) {
    logger.d("페이먼트 로딩:$status");
    _model.paymentLodding = status;
    notifyListeners();
  }
}
