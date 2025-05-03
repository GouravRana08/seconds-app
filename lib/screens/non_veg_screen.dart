// lib/screens/non_veg_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class NonVegScreen extends StatefulWidget {
  final Function(Product) onAddToCart;

  const NonVegScreen({Key? key, required this.onAddToCart}) : super(key: key);

  @override
  State<NonVegScreen> createState() => _NonVegScreenState();
}

class _NonVegScreenState extends State<NonVegScreen> {
  final List<Product> products = [
    Product(
        id: 'nv1', name: 'Chicken Breast', price: 8.00, discountedPrice: 7.00),
    Product(
        id: 'nv2', name: 'Salmon Fillet', price: 10.00, discountedPrice: 9.00),
    Product(
        id: 'nv3', name: 'Eggs (Dozen)', price: 5.00, discountedPrice: 4.50),
    Product(
        id: 'nv4', name: 'Shrimp (500g)', price: 9.50, discountedPrice: 8.50),
  ];
  final Map<String, int> _itemQuantities = {};

  void _incrementItem(Product product) {
    setState(() {
      _itemQuantities[product.name] = (_itemQuantities[product.name] ?? 0) + 1;
    });
  }

  void _decrementItem(Product product) {
    setState(() {
      if (_itemQuantities.containsKey(product.name) &&
          _itemQuantities[product.name]! > 0) {
        _itemQuantities[product.name] = _itemQuantities[product.name]! - 1;
        if (_itemQuantities[product.name] == 0) {
          _itemQuantities.remove(product.name);
        }
      }
    });
  }

  void _addToCart(Product product) {
    if (_itemQuantities.containsKey(product.name) &&
        _itemQuantities[product.name]! > 0) {
      widget.onAddToCart(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${_itemQuantities[product.name]} x ${product.name} added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a quantity to add to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Non-Veg'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final quantity = _itemQuantities[product.name] ?? 0;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 16.0)),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '\$${product.discountedPrice?.toStringAsFixed(2) ?? product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _decrementItem(product),
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16.0)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _incrementItem(product),
                    ),
                    ElevatedButton(
                      onPressed: () => _addToCart(product),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
