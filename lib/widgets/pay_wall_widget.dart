import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:exchange_rate_app/controller/payment_controller.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class PaywllWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<ProductDetails> packages;
  final ValueChanged<ProductDetails> onClickedPackage;
  const PaywllWidget({
    super.key,
    required this.title,
    required this.description,
    required this.packages,
    required this.onClickedPackage,
  });

  @override
  State<PaywllWidget> createState() => _PaywllWidgetState();
}

class _PaywllWidgetState extends State<PaywllWidget> {
  // final bool _kAutoConsume = Platform.isIOS || true;

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late PaymentController _paymentController;
  // late bool paymentLodding;

  Future<void> paymentServerSave(Map<String, dynamic> verificationData) async {
    final String baseUrl = dotenv.get("SERVER_URL");
    final User? userInstance = FirebaseAuth.instance.currentUser;
    final String? userUid = userInstance?.uid;
    final String? userEmaill = userInstance?.email;
    logger.d("uid:$userUid");
    final dio = Dio();
    try {
      await dio.post(
        '$baseUrl/payment/itemSave',
        data: {
          "userUid": userUid,
          "userEmail": userEmaill,
          "orderId": verificationData['orderId'],
          "packageName": verificationData['packageName'],
          "productId": verificationData['productId'],
          "purchaseTime": verificationData['purchaseTime'],
          "purchaseState": verificationData['purchaseState'],
          "purchaseToken": verificationData['purchaseToken'],
          "quantity": verificationData['quantity']
        },
      );
    } catch (e) {
      logger.d("서버 요청에러:$e");
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          logger.d("결제:pending");
          _paymentController.setPaymentLodding(true);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          logger.d("결제중");
          break;
        case PurchaseStatus.error:
          logger.d("결제에러:${purchaseDetails.error}");
          break;
        default:
          break;
      }
      logger.d(
          "pendingCompletePurchase:${purchaseDetails.pendingCompletePurchase}");

      if (purchaseDetails.pendingCompletePurchase) {
        logger.d("서버에 결제정보 저장시작");
        final verificationDataJson =
            json.decode(purchaseDetails.verificationData.localVerificationData);
        await paymentServerSave(verificationDataJson);
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
      _paymentController.setPaymentLodding(false);
    });
  }

  @override
  void initState() {
    _paymentController = Provider.of<PaymentController>(context, listen: false);
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    // paymentLodding = false;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      // logger.d("purchaseDetailsList:${purchaseDetailsList}");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
      logger.d("error:$error");
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    logger.d("위젯:dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentController>(
      builder: (context, value, child) {
        if (value.paymentLodding == true) {
          return const Padding(
            padding: EdgeInsets.all(90.0),
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [Colors.blue, Colors.red, Colors.green],
            ),
          );
        } else {
          return SingleChildScrollView(
            // padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Text(widget.title),
                const SizedBox(
                  height: 16,
                ),
                // Text(widget.description),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildPackages(),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildPackages() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: widget.packages.length,
      itemBuilder: (context, index) {
        final package = widget.packages[index];
        return buildPackage(context, package);
      },
    );
  }

  Widget buildPackage(BuildContext context, ProductDetails package) {
    // final product = package.storeProduct;
    return Card(
      child: ListTile(
        title: Text(package.title),
        subtitle: Text(package.description),
        trailing: Text(package.price),
        onTap: () => widget.onClickedPackage(package),
      ),
    );
  }
}
