import 'package:flutter/material.dart';

class KaggaDetailsScreen extends StatelessWidget {
  const KaggaDetailsScreen({super.key, required this.kagga_id});

  final String kagga_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ಕಗ್ಗ $kagga_id'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      drawer: const Drawer(
          // Add your drawer contents here
          ),
    );
  }
}
