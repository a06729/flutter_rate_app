import 'package:exchange_rate_app/services/purchase_api.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../widgets/pay_wall_widget.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                // final List<ProductDetails> productDetails =
                //     await PurchaseApi.fetch();
                await fetchOffers();
                // PurchaseParam purchaseParam =
                //     PurchaseParam(productDetails: productDetails[0]);
                // await InAppPurchase.instance
                //     .buyConsumable(purchaseParam: purchaseParam);
              },
              child: Text("상품"),
            )
          ],
        ),
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
    final offerings = await PurchaseApi.fetch();
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("아이템이 없습니다."),
        ),
      );
    } else {
      final packages = offerings;
      showSheet(packages);
    }
  }
}
