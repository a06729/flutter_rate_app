import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

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
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<void> paymentServerSave(Map<String, dynamic> verificationData) async {
    final String baseUrl = dotenv.get("SERVER_URL");
    final User? userInstance = FirebaseAuth.instance.currentUser;
    final String? userUid = userInstance?.uid;
    final String? userEmaill = userInstance?.email;
    logger.d("uid:$userUid");
    final dio = Dio();
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
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
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
        final verificationDataJson =
            json.decode(purchaseDetails.verificationData.localVerificationData);
        await paymentServerSave(verificationDataJson).then(
          (value) async =>
              await InAppPurchase.instance.completePurchase(purchaseDetails),
        );

        return;
      }
    });
  }

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      // logger.d("purchaseDetailsList:${purchaseDetailsList}");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.title),
            const SizedBox(
              height: 16,
            ),
            Text(widget.description),
            buildPackages()
          ],
        ),
      ),
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
