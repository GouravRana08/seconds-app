// lib/screens/product_view_screen.dart
import 'package:flutter/material.dart';

class ProductViewScreen extends StatelessWidget {
  const ProductViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Products'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with your actual product count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Product ${index + 1}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Description of the product goes here.'),
                  const SizedBox(height: 8),
                  const Text('Price: ₹XX.XX (Viewing Only)'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
