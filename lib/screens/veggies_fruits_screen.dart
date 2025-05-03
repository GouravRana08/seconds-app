// lib/screens/veggies_fruits_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class VeggiesFruitsScreen extends StatefulWidget {
  final Function(Product) onAddToCart;

  const VeggiesFruitsScreen({Key? key, required this.onAddToCart})
      : super(key: key);

  @override
  State<VeggiesFruitsScreen> createState() => _VeggiesFruitsScreenState();
}

class _VeggiesFruitsScreenState extends State<VeggiesFruitsScreen> {
  final List<Product> products = [
    Product(id: 'veg_1', name: 'Apples', price: 1.50, discountedPrice: 1.20),
    Product(id: 'veg_2', name: 'Bananas', price: 0.80, discountedPrice: 0.60),
    Product(id: 'veg_3', name: 'Carrots', price: 1.00, discountedPrice: 0.75),
    Product(id: 'veg_4', name: 'Tomatoes', price: 2.00, discountedPrice: 1.80),
    Product(id: 'veg_5', name: 'Spinach', price: 2.50, discountedPrice: 2.00),
    Product(id: 'veg_6', name: 'Mangoes', price: 3.00, discountedPrice: 2.50),
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
        title: const Text('Fruits & Veggies'),
        backgroundColor: Colors.green,
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
