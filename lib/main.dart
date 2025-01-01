import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:kagga/kagga_db_helper.dart';
import 'package:kagga/kagga_list_screen.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database db = await initializeDatabase();
  List<Map<String, dynamic>> kaggaList = await getKaggaList(db);
  runApp(KaggaApp(kaggaList: kaggaList));
}

class KaggaApp extends StatelessWidget {
  final List<Map<String, dynamic>> kaggaList;

  const KaggaApp({super.key, required this.kaggaList});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      home: PlatformScaffold(
        body: KaggaListScreen(title: 'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ', kaggaList: kaggaList),
      ),
    );
  }
}
