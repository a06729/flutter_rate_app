import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'goog_bMqcaDVsPEVQLuCkzqPXEpVfiPo';
  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  // static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
  //   final offers = await fetchOffers();
  //   return offers.where((offer) => ids.contains(offer.identifier)).toList();
  // }

  static Future<List<Offering>> fetchOffers({bool all = true}) async {
    try {
      final offerings = await Purchases.getOfferings();
      if (!all) {
        final current = offerings.current;
        print("current:${current}");
        return current == null ? [] : [current];
      } else {
        return offerings.all.values.toList();
      }
    } on PlatformException catch (e) {
      print("결제 모듈 에러");
      print(e);
      return [];
    }
  }

  static purchasePackage(Package package) async {
    final isSuccess = await Purchases.purchasePackage(package);
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    logger.d("isSuccess:${isSuccess.toJson()}");
  }
}
