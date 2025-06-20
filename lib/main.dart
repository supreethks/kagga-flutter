import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kagga/db/kagga_db_helper.dart';
import 'package:kagga/kagga_list_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kagga/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize notifications
  await NotificationService().initialize();

  Database db = await initializeDatabase();
  List<Map<String, dynamic>> kaggaList = await getKaggaList(db);
  runApp(KaggaApp(kaggaList: kaggaList));
}

class KaggaApp extends StatelessWidget {
  final List<Map<String, dynamic>> kaggaList;

  const KaggaApp({super.key, required this.kaggaList});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: KaggaListScreen(
        title: 'ಮಂಕುತಿಮ್ಮನ ಕಗ್ಗ',
        kaggaList: kaggaList,
      ),
    );
  }
}
