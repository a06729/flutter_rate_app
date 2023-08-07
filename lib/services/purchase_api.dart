import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseApi {
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  //상품을 결제하기 위한 함수
  static purchasePackage(ProductDetails package) async {
    final bool kAutoConsume = Platform.isIOS || true;
    PurchaseParam purchaseParam = PurchaseParam(productDetails: package);
    if (package.id == kAutoConsume) {
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: kAutoConsume,
      );
    } else {
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
    return;
  }

  //상품정보를 가져오기 위한 함수
  Future<List<ProductDetails>> fetch() async {
    //상품정보의 key값을 ids변수에 저장
    Set<String> ids = Set<String>.from([
      'coin_10',
      'coin_30',
      'coin_50',
      'coin_100.',
    ]);

    //인앱결제가 가능한지 안한지 체크하는 변수
    final bool available = await InAppPurchase.instance.isAvailable();

    if (available) {
      ProductDetailsResponse res =
          await _inAppPurchase.queryProductDetails(ids);

      List<ProductDetails> ascOrderProductDetails = res.productDetails.toList()
        ..sort((e1, e2) => e1.price.compareTo(e2.price));
      //상품정보를 리턴
      return ascOrderProductDetails;
    } else {
      return [];
    }
  }
}
