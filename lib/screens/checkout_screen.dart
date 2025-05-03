import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String deliveryAddress = '';
  String? selectedPayment;
  String? selectedUPIApp;
  TextEditingController upiIdController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  List<Map<String, String>> savedAddresses = [];
  String? selectedSavedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressesJson = prefs.getString('profile_addresses');
    if (addressesJson != null) {
      try {
        List<dynamic> decodedList = jsonDecode(addressesJson) as List;
        setState(() {
          savedAddresses = decodedList.cast<Map<String, String>>();
        });
      } catch (e) {
        print('Error decoding addresses: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address
            const Text('Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select saved address (optional)',
                border: OutlineInputBorder(),
              ),
              value: selectedSavedAddress,
              items: savedAddresses.map((address) {
                final fullAddress =
                    '${address['name']}, ${address['phone']}, ${address['address']}';
                return DropdownMenuItem<String>(
                  value: fullAddress,
                  child: Text(fullAddress),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSavedAddress = value;
                  deliveryAddress = value ?? '';
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your delivery address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              initialValue: deliveryAddress,
              onChanged: (value) {
                setState(() {
                  deliveryAddress = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Payment Option
            const Text('Payment Option',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RadioListTile<String>(
              title: const Text('Credit/Debit Card'),
              value: 'card',
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value;
                  selectedUPIApp = null;
                });
              },
            ),
            if (selectedPayment == 'card')
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: cardNumberController,
                      decoration: const InputDecoration(
                          labelText: 'Card Number',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expiryController,
                            decoration: const InputDecoration(
                                labelText: 'Expiry (MM/YY)',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: cvvController,
                            decoration: const InputDecoration(
                                labelText: 'CVV', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle card payment logic here
                        print(
                            'Card Number: ${cardNumberController.text}, Expiry: ${expiryController.text}, CVV: ${cvvController.text}');
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Card details entered (no actual payment)')));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            RadioListTile<String>(
              title: const Text('UPI'),
              value: 'upi',
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value;
                });
              },
            ),
            if (selectedPayment == 'upi')
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<String>(
                      title: const Text('Google Pay'),
                      value: 'gpay',
                      groupValue: selectedUPIApp,
                      onChanged: (value) {
                        setState(() {
                          selectedUPIApp = value;
                          upiIdController.clear();
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('PhonePe'),
                      value: 'phonepe',
                      groupValue: selectedUPIApp,
                      onChanged: (value) {
                        setState(() {
                          selectedUPIApp = value;
                          upiIdController.clear();
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Paytm'),
                      value: 'paytm',
                      groupValue: selectedUPIApp,
                      onChanged: (value) {
                        setState(() {
                          selectedUPIApp = value;
                          upiIdController.clear();
                        });
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Radio<String>(
                            value: 'other',
                            groupValue: selectedUPIApp,
                            onChanged: (value) {
                              setState(() {
                                selectedUPIApp = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: upiIdController,
                            decoration: const InputDecoration(
                                labelText: 'Enter UPI ID',
                                border: OutlineInputBorder()),
                            enabled: selectedUPIApp == 'other',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        String message = 'UPI option selected: ';
                        if (selectedUPIApp == 'gpay' ||
                            selectedUPIApp == 'phonepe' ||
                            selectedUPIApp == 'paytm') {
                          message += selectedUPIApp!;
                        } else if (selectedUPIApp == 'other' &&
                            upiIdController.text.isNotEmpty) {
                          message += 'UPI ID: ${upiIdController.text}';
                        } else {
                          message = 'Please select a UPI app or enter UPI ID';
                        }
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                        // Handle UPI payment logic here
                        print(message);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            RadioListTile<String>(
              title: const Text('Cash on Delivery'),
              value: 'cod',
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value;
                  selectedUPIApp = null;
                });
              },
            ),
            if (selectedPayment == 'cod')
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle COD logic here
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Cash on Delivery selected')));
                    print('Cash on Delivery selected');
                  },
                  child: const Text('OK'),
                ),
              ),
            const SizedBox(height: 20),

            // Checkout Button
            ElevatedButton(
              onPressed: () {
                if (deliveryAddress.isNotEmpty && selectedPayment != null) {
                  // Proceed to actual checkout logic
                  print(
                      'Proceeding to checkout with address: $deliveryAddress and payment: $selectedPayment');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Checkout initiated (no actual transaction)')));
                  // You would typically navigate to a confirmation screen or process the order here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Please select delivery address and payment option')));
                }
              },
              child: const Text('Checkout'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
