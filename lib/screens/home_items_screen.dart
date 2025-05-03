// lib/screens/home_items_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class HomeItemsScreen extends StatefulWidget {
  final Function(Product) onAddToCart;

  const HomeItemsScreen({Key? key, required this.onAddToCart})
      : super(key: key);

  @override
  State<HomeItemsScreen> createState() => _HomeItemsScreenState();
}

class _HomeItemsScreenState extends State<HomeItemsScreen> {
  final List<Product> products = [
    Product(
        id: 'home_1',
        name: 'Dish Soap (500ml)',
        price: 4.00,
        discountedPrice: 3.50),
    Product(
        id: 'home_2',
        name: 'Laundry Detergent (1L)',
        price: 9.00,
        discountedPrice: 8.00),
    Product(
        id: 'home_3',
        name: 'Paper Towels (Single Roll)',
        price: 2.50,
        discountedPrice: 2.00),
    Product(
        id: 'home_4',
        name: 'Toilet Paper (4 Rolls)',
        price: 7.00,
        discountedPrice: 6.00),
    Product(
        id: 'home_5',
        name: 'Garbage Bags (Small Pack)',
        price: 3.00,
        discountedPrice: 2.50),
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
        title: const Text('Groceries & House Items'),
        backgroundColor: Colors.deepPurple,
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
                Expanded(
                  // Wrapped the left Column with Expanded
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: const TextStyle(fontSize: 16.0)),
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
                ),
                const SizedBox(
                    width: 8.0), // Added some spacing between the two rows
                Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure the right Row takes only necessary space
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _decrementItem(product),
                    ),
                    SizedBox(
                      width: 30, // Fixed width for quantity text
                      child: Text(
                        '$quantity',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
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
