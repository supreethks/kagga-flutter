import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDatabase() async {
  // Get the path to the documents directory.
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'kagga_v5.db');

  // Check if the database exists
  var exists = await databaseExists(path);

  if (!exists) {
    // If it doesn't exist, copy it from the assets
    print('Copying database from assets');
    ByteData data = await rootBundle.load('assets/kagga_v5.sqlite');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes to the file
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    print('Opening existing database');
  }

  // Open the database
  return await openDatabase(path);
}

Future<List<Map<String, dynamic>>> getKaggaList(Database db) async {
  final List<Map<String, dynamic>> maps = await db.query('mankutimma');

  return List.generate(maps.length, (i) {
    return {
      'number': maps[i]['kagga_id'].toString(),
      'content': maps[i]['kagga_kn'],
    };
  });
}
