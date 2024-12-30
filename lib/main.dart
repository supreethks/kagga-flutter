import 'package:flutter/material.dart';
import 'package:kagga_flutter/kagga_db_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database db = await initializeDatabase();
  List<Map<String, dynamic>> kaggaList = await getKaggaList(db);
  print("items in the list ${kaggaList.length}");
  runApp(KaggaApp(kaggaList: kaggaList));
}

class KaggaApp extends StatelessWidget {
  final List<Map<String, dynamic>> kaggaList;

  const KaggaApp({super.key, required this.kaggaList});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kagga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: KaggaListScreen(title: 'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ', kaggaList: kaggaList),
    );
  }
}

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
            number: kaggaList[index]['number']!,
            content: kaggaList[index]['content']!,
          );
        },
      ),
    );
  }
}

class KaggaItem extends StatelessWidget {
  final String number;
  final String content;

  const KaggaItem({super.key, required this.number, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
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
    );
  }
}
