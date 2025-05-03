// lib/screens/seconds_cafe_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class SecondsCafeScreen extends StatefulWidget {
  final Function(Product) onAddToCart;

  const SecondsCafeScreen({Key? key, required this.onAddToCart})
      : super(key: key);

  @override
  State<SecondsCafeScreen> createState() => _SecondsCafeScreenState();
}

class _SecondsCafeScreenState extends State<SecondsCafeScreen> {
  final List<Product> products = [
    Product(id: 'cafe_1', name: 'Coffee', price: 2.50, discountedPrice: 2.00),
    Product(id: 'cafe_2', name: 'Sandwich', price: 5.00, discountedPrice: 4.50),
    Product(id: 'cafe_3', name: 'Pastry', price: 3.00, discountedPrice: 2.70),
    Product(id: 'cafe_4', name: 'Juice', price: 3.50, discountedPrice: 3.00),
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
        title: const Text('Seconds Cafe'),
        backgroundColor: Colors.amber,
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
