import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
