import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Import the file for your login screen
import 'login_page.dart'; // Assuming login_page.dart is in the same directory

class UserProfileScreen extends StatefulWidget {
  final String? userEmail;

  const UserProfileScreen({super.key, this.userEmail});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Map<String, String>> userAddresses = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? _selectedGender;
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController newAddressController = TextEditingController();
  String selectedEmoji = '👤';

  List<String> profileEmojis = [
    '👦',
    '👧',
    '🧑',
    '👩',
    '👶',
    '👧🏼',
    '👦🏽',
    '👩🏻',
    '👨🏿',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    emailController.text = widget.userEmail ?? '';
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing data if available
    String? storedName = prefs.getString('profile_name');
    String? storedPhone = prefs.getString('profile_phone');
    String? storedGender = prefs.getString('profile_gender');
    String? storedEmoji = prefs.getString('profile_emoji');
    String? addressesJson = prefs.getString('profile_addresses');

    setState(() {
      // Initialize with stored data or empty values
      nameController.text = storedName ?? '';
      phoneController.text = storedPhone ?? '';
      emailController.text =
          widget.userEmail ?? ''; // Email should be pre-filled

      // Gender and Emoji are nullable and have defaults
      _selectedGender = storedGender;
      selectedEmoji = storedEmoji ?? '👤';

      // Load addresses if present
      if (addressesJson != null) {
        try {
          List<dynamic> decodedList = jsonDecode(addressesJson) as List;
          userAddresses = decodedList.map((item) {
            return <String, String>{
              'name': item['name'] as String,
              'phone': item['phone'] as String,
              'address': item['address'] as String,
            };
          }).toList();
        } catch (e) {
          print('Error decoding addresses: $e');
          userAddresses = [];
        }
      } else {
        userAddresses = [];
      }
    });
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String? gender = _selectedGender;
    String emoji = selectedEmoji;
    String addressesJson = jsonEncode(userAddresses);

    await prefs.setString('profile_name', name);
    await prefs.setString('profile_phone', phone);
    await prefs.setString('profile_email', email);
    await prefs.setString('profile_gender', gender ?? '');
    await prefs.setString('profile_emoji', emoji);
    await prefs.setString('profile_addresses', addressesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile data saved locally!')),
    );
  }

  void _addNewAddress() {
    if (newNameController.text.isNotEmpty &&
        newPhoneController.text.isNotEmpty &&
        newAddressController.text.isNotEmpty) {
      setState(() {
        userAddresses.add(<String, String>{
          // Explicitly create a Map<String, String>
          'name': newNameController.text,
          'phone': newPhoneController.text,
          'address': newAddressController.text,
        });
        newNameController.clear();
        newPhoneController.clear();
        newAddressController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all address fields')),
      );
    }
  }

  void _deleteAddress(int index) {
    setState(() {
      userAddresses.removeAt(index);
    });
  }

  void _selectEmoji(String emoji) {
    setState(() {
      selectedEmoji = emoji;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_name');
    await prefs.remove('profile_phone');
    await prefs.remove('profile_email');
    await prefs.remove('profile_gender');
    await prefs.remove('profile_emoji');
    await prefs.remove('profile_addresses');

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginPage()), // Ensure 'LoginPage' is the correct widget name
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (newPassword.isNotEmpty && newPassword == confirmPassword) {
                  // In a real app, you would securely handle the password change.
                  // Storing passwords directly in SharedPreferences is insecure.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Password changed successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Passwords do not match or are empty.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name'),
            TextFormField(controller: nameController),
            const SizedBox(height: 20),
            const Text('Email'),
            TextFormField(controller: emailController),
            const SizedBox(height: 20),
            const Text('Gender'),
            Row(
              children: [
                Radio<String>(
                    value: 'Male',
                    groupValue: _selectedGender ?? '',
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    }),
                const Text('Male'),
                const SizedBox(width: 10),
                Radio<String>(
                    value: 'Female',
                    groupValue: _selectedGender ?? '',
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    }),
                const Text('Female'),
                const SizedBox(width: 10),
                Radio<String>(
                    value: 'Other',
                    groupValue: _selectedGender ?? '',
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    }),
                const Text('Other'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Phone Number'),
            TextFormField(controller: phoneController),
            const SizedBox(height: 20),
            const Text('Profile Emoji'),
            Wrap(
              spacing: 8.0,
              children: profileEmojis
                  .map((emoji) => InkWell(
                        onTap: () => _selectEmoji(emoji),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedEmoji == emoji
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showChangePasswordDialog(context);
              },
              child: const Text('Change Password'),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saved Addresses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (userAddresses.isEmpty)
                    const Text('No saved addresses yet.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userAddresses.length,
                      itemBuilder: (context, index) {
                        final addressInfo = userAddresses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${addressInfo['name']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Phone: ${addressInfo['phone']}'),
                                    Text('Address: ${addressInfo['address']}'),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  _deleteAddress(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newNameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newPhoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newAddressController,
                    decoration: const InputDecoration(
                      hintText: 'Delivery Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: _addNewAddress,
                      child: const Text('Save Address')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: _saveProfile, child: const Text('Save')),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
