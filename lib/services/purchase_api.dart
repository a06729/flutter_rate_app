import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

class PurchaseApi {
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  static var logger = Logger(
    printer: PrettyPrinter(),
  );

  static purchasePackage(ProductDetails package) async {
    final bool kAutoConsume = Platform.isIOS || true;
    _inAppPurchase.purchaseStream.listen((event) {
      PurchaseDetails e = event[0];
      logger.d("eventlen:${event.length}");
      logger.d(
          "event:$e ${e.status} ${e.productID} ${e.pendingCompletePurchase} ${e.verificationData.localVerificationData}");
    });
    PurchaseParam purchaseParam = PurchaseParam(productDetails: package);
    if (package.id == kAutoConsume) {
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: kAutoConsume,
      );
    } else {
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  static Future<List<ProductDetails>> fetch() async {
    Set<String> ids = Set<String>.from(['coin_10', 'coin_100']);

    final bool available = await InAppPurchase.instance.isAvailable();

    if (available) {
      ProductDetailsResponse res =
          await _inAppPurchase.queryProductDetails(ids);

      return res.productDetails;
    } else {
      return [];
    }
  }
}
