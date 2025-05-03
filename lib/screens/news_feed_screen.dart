// lib/screens/news_feed_screen.dart
import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
      ),
      body: Center(
        child: const Text('Daily Discounted Prices Will Be Shown Here!'),
      ),
    );
  }
}
