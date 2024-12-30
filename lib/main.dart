import 'package:flutter/material.dart';
import 'package:kagga_flutter/kagga_db_helper.dart';
import 'package:kagga_flutter/kagga_list_screen.dart';
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
