import 'package:flutter/material.dart';
import 'package:kagga_flutter/kagga_details_screen.dart';

class KaggaListScreen extends StatelessWidget {
  const KaggaListScreen(
      {super.key, required this.title, required this.kaggaList});

  final String title;
  final List<Map<String, dynamic>> kaggaList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      drawer: const Drawer(
          // Add your drawer contents here
          ),
      body: ListView.builder(
        itemCount: kaggaList.length,
        itemBuilder: (context, index) {
          print("items in the list ${kaggaList.length}");
          return KaggaItem(
            kagga_id: kaggaList[index]['kagga_id']!,
            content: kaggaList[index]['kagga_kn']!,
          );
        },
      ),
    );
  }
}

class KaggaItem extends StatelessWidget {
  final String kagga_id;
  final String content;

  const KaggaItem({super.key, required this.kagga_id, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KaggaDetailsScreen(kagga_id: kagga_id),
            ),
          );
        },
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kagga_id,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
