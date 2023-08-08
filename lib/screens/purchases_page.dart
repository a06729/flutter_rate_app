import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:exchange_rate_app/services/purchase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lottie/lottie.dart';
import 'package:workmanager/workmanager.dart';
import '../widgets/pay_wall_widget.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
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
          "pendingCompletePurchase_purchasesPage:${purchaseDetails.pendingCompletePurchase}");
      if (purchaseDetails.pendingCompletePurchase) {
        Map<String, dynamic> verificationDataJson =
            json.decode(purchaseDetails.verificationData.localVerificationData);

        final User? userInstance = FirebaseAuth.instance.currentUser;
        final String? userUid = userInstance?.uid;
        final String? userEmaill = userInstance?.email;

        //유저 uid를 json에 추가
        verificationDataJson['userUid'] = userUid;
        //유저 이메일을 json에 추가
        verificationDataJson['userEmaill'] = userEmaill;

        await InAppPurchase.instance.completePurchase(purchaseDetails).then(
              (value) => {
                //백그라운드에서 작업할수 있도록 하는것
                Workmanager().registerOneOffTask(
                  "payment_identifier", //worker매니저의 고유 키값
                  "paymentTask", //worker매니저의 실행되는 태스크 이름
                  inputData: verificationDataJson,
                  constraints: Constraints(networkType: NetworkType.connected),
                )
              },
            );
        // await paymentServerSave(verificationDataJson).then((value) async =>
        //     await InAppPurchase.instance.completePurchase(purchaseDetails));

        return;
      }
    });
  }

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      logger.d("purchaseDetailsList:${purchaseDetailsList}");
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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: fetchOffers(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/pyment_required.json',
                        height: 300,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("코인이 부족합니다 충전이 필요합니다"),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final package = snapshot.data[index];
                          return buildPackage(context, package);
                        },
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildPackage(BuildContext context, ProductDetails package) {
    return Card(
      child: ListTile(
        title: Text(package.title),
        subtitle: Text(package.description),
        trailing: Text(package.price),
        onTap: () async => await PurchaseApi.purchasePackage(package),
      ),
    );
  }

  showSheet(List<ProductDetails> packages) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return PaywllWidget(
          packages: packages,
          title: '',
          description: '',
          onClickedPackage: (packages) async {
            await PurchaseApi.purchasePackage(packages);
          },
        );
      },
    );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi().fetch();
    if (offerings.isEmpty) {
      return [];
    } else {
      final packages = offerings;
      return packages;
      // showSheet(packages);
    }
  }
}
