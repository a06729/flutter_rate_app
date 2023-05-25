import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywllWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;
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

  Widget buildPackage(BuildContext context, Package package) {
    final product = package.storeProduct;

    return Card(
      child: ListTile(
        title: Text(product.title),
        subtitle: Text(product.description),
        trailing: Text(product.priceString),
        onTap: () => widget.onClickedPackage(package),
      ),
    );
  }
}
