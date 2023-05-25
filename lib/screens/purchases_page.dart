import 'package:exchange_rate_app/services/purchase_api.dart';
import 'package:flutter/material.dart';
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
                await fetchOffers();
              },
              child: Text("상품"),
            )
          ],
        ),
      ),
    );
  }

  showSheet(packages) {
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
    final offerings = await PurchaseApi.fetchOffers(all: true);
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("아이템이 없습니다."),
        ),
      );
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      showSheet(packages);
    }
  }
}
