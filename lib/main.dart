// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart'; // Ensure this path is correct
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seconds App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(), // It should be LoginPage, not LoginUserProfile
      routes: {
        '/cart': (context) => Consumer<CartProvider>(
              builder: (context, cartProvider, child) => CartScreen(
                cartItems: cartProvider.cartItems,
                onRemoveFromCart: cartProvider.removeFromCart,
              ),
            ),
      },
    );
  }
}
