import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key, this.productName}) : super(key: key);

  final String? productName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName ?? 'Product Details'),
      ),
      body: Center(
        child: Text(productName != null
            ? 'Details for $productName'
            : 'No product selected.'),
      ),
    );
  }
}
