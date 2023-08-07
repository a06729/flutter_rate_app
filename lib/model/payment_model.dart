class PaymentModel {
  bool _paymentLodding = false;

  set paymentLodding(bool status) {
    _paymentLodding = status;
  }

  bool get paymentLodding => _paymentLodding;
}
