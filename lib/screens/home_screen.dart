// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'seconds_cafe_screen.dart';
import 'veggies_fruits_screen.dart';
import 'non_veg_screen.dart';
import 'home_items_screen.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'user_profile_screen.dart';
import 'login_page.dart';
import 'sign_up.dart';
import 'news_feed_screen.dart'; // Import the NewsFeedScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Seconds Cafe',
      'icon': Icons.local_cafe_outlined,
      'color': const Color(0xFFFDD835)
    }, // Yellow
    {
      'name': 'Fruits & Veggies',
      'icon': Icons.shopping_cart_outlined,
      'color': const Color(0xFF4CAF50)
    }, // Green
    {
      'name': 'Non-Veg',
      'icon': Icons.restaurant_outlined,
      'color': const Color(0xFFE57373)
    }, // Red
    {
      'name': 'Groceries & House\nItems',
      'icon': Icons.home_outlined,
      'color': const Color(0xFF9575CD)
    }, // Purple
  ];

  final List<String> bannerImages = [
    'assets/ipl_banner.png',
    'assets/seconds_cafe_offer.png',
    'assets/specialoffer_simple.png',
  ];

  final List<Product> _cartItems = [];

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });
    debugPrint('Item added to cart: ${product.name}');
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cartItems.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? loggedInEmail = SignUpScreen.users.keys.isNotEmpty
        ? SignUpScreen.users.keys.first
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(userEmail: loggedInEmail)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Slider
          SizedBox(
            height: 150, // Adjust height as needed for your banners
            width: double.infinity,
            child: PageView.builder(
              itemCount: bannerImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      bannerImages[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Widget categoryScreen;
                    switch (categories[index]['name']) {
                      case 'Seconds Cafe':
                        categoryScreen =
                            SecondsCafeScreen(onAddToCart: _addToCart);
                        break;
                      case 'Fruits & Veggies':
                        categoryScreen =
                            VeggiesFruitsScreen(onAddToCart: _addToCart);
                        break;
                      case 'Non-Veg':
                        categoryScreen = NonVegScreen(onAddToCart: _addToCart);
                        break;
                      case 'Groceries & House\nItems':
                        categoryScreen =
                            HomeItemsScreen(onAddToCart: _addToCart);
                        break;
                      default:
                        categoryScreen =
                            const Center(child: Text('Coming Soon'));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => categoryScreen),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: categories[index]['color']?.withOpacity(0.8) ??
                          Colors.grey[400],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categories[index]['icon'],
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          categories[index]['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartScreen(
                    cartItems: _cartItems, onRemoveFromCart: _removeFromCart)),
          );
        },
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined), // News Feed Icon
            label: 'News Feed', // News Feed Label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const NewsFeedScreen()), // Navigate to NewsFeedScreen
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartScreen(
                      cartItems: _cartItems,
                      onRemoveFromCart: _removeFromCart)),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserProfileScreen(userEmail: loggedInEmail)),
            );
          }
          // You can add navigation for the Home button (index 0) if needed.
        },
      ),
    );
  }
}
