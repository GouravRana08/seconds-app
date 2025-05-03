// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:geolocator/geolocator.dart'; // Import for location

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;
  final Function(Product) onRemoveFromCart; // Callback to remove item

  const CartScreen(
      {super.key, required this.cartItems, required this.onRemoveFromCart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? selectedPaymentOption;
  TextEditingController addressController = TextEditingController();
  bool isCheckoutEnabled = false;
  bool isOrderPlaced = false;
  String deliveryBoyName = "Ramesh"; // Dummy delivery boy name
  String deliveryBoyPhone = "+91 9876543210"; // Dummy delivery boy phone
  String userName = "User123"; // Dummy user name
  String userPhone = "+91 1234567890"; // Dummy user phone
  Position? deliveryBoyLocation; // To store delivery boy's location

  @override
  void initState() {
    super.initState();
    _checkCheckoutEnabled();
    _getDeliveryBoyLocation(); // Simulate fetching delivery boy location
  }

  void _checkCheckoutEnabled() {
    setState(() {
      isCheckoutEnabled = widget.cartItems.isNotEmpty &&
          addressController.text.isNotEmpty &&
          selectedPaymentOption != null;
    });
  }

  Future<void> _simulateCheckout() async {
    if (isCheckoutEnabled) {
      setState(() {
        isOrderPlaced = true;
        widget.cartItems.clear(); // Clear the cart after order
      });

      // Simulate order processing time
      await Future.delayed(const Duration(seconds: 3));

      // You would typically navigate to an order confirmation screen here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Thanks for placing your order! Your cart is now empty.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in address and select payment option.')),
      );
    }
  }

  Future<void> _getDeliveryBoyLocation() async {
    // Simulate fetching delivery boy's location
    // In a real app, you would use a service to get the live location
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      deliveryBoyLocation = Position(
        latitude: 12.9716,
        longitude: 77.5946, // Dummy Bengaluru coordinates
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0, // Added altitudeAccuracy
        headingAccuracy: 0.0, // Added headingAccuracy
      );
    });
  }

  void _removeItem(Product product) {
    setState(() {
      widget.onRemoveFromCart(product);
      _checkCheckoutEnabled(); // Update checkout button state
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} removed from cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    for (var item in widget.cartItems) {
      totalAmount += item.discountedPrice ?? item.price;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.cartItems.isEmpty)
              const Center(
                child: Text('Your cart is empty'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '\$${(item.discountedPrice ?? item.price).toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            const Text('Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your delivery address',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _checkCheckoutEnabled(),
            ),
            const SizedBox(height: 20),
            const Text('Payment Option',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Credit/Debit Card'),
              value: 'card',
              groupValue: selectedPaymentOption,
              onChanged: (value) {
                setState(() {
                  selectedPaymentOption = value;
                });
                _checkCheckoutEnabled();
              },
            ),
            RadioListTile<String>(
              title: const Text('UPI'),
              value: 'upi',
              groupValue: selectedPaymentOption,
              onChanged: (value) {
                setState(() {
                  selectedPaymentOption = value;
                });
                _checkCheckoutEnabled();
              },
            ),
            RadioListTile<String>(
              title: const Text('Cash on Delivery'),
              value: 'cod',
              groupValue: selectedPaymentOption,
              onChanged: (value) {
                setState(() {
                  selectedPaymentOption = value;
                });
                _checkCheckoutEnabled();
              },
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: isCheckoutEnabled && !isOrderPlaced
                    ? _simulateCheckout
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCheckoutEnabled && !isOrderPlaced
                      ? null
                      : Colors.grey, // Disable color
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Checkout', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.cartItems.isNotEmpty)
              Center(
                child: Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            if (isOrderPlaced) ...[
              const SizedBox(height: 30),
              const Text('Order Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Delivery in seconds!'),
              const SizedBox(height: 10),
              const Text('Delivery Boy Information:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Name: $deliveryBoyName'),
              Text('Phone: $deliveryBoyPhone'),
              const SizedBox(height: 10),
              const Text('Your Information:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Name: $userName'),
              Text('Phone: $userPhone'),
              Text('Address: ${addressController.text}'),
              if (deliveryBoyLocation != null) ...[
                const SizedBox(height: 10),
                const Text('Delivery Boy Location:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    'Latitude: ${deliveryBoyLocation!.latitude.toStringAsFixed(4)}'),
                Text(
                    'Longitude: ${deliveryBoyLocation!.longitude.toStringAsFixed(4)}'),
                // In a real app, you would display this on a map
              ],
            ],
          ],
        ),
      ),
    );
  }
}
