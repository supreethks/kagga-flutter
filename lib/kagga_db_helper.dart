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
    ByteData data = await rootBundle.load('assets/kagga_v5.sqlite');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes to the file
    await File(path).writeAsBytes(bytes, flush: true);
  } else {}

  // Open the database
  return await openDatabase(path);
}

Future<int> getDatabaseVersion() async {
  final db = await initializeDatabase();
  final version = await db.query('sqlite_master',
      where: 'type = ? AND name = ?', whereArgs: ['table', 'mankutimma']);
  return version.length;
}

Future<List<Map<String, dynamic>>> getKaggaList(Database db) async {
  final List<Map<String, dynamic>> maps = await db.query('mankutimma');

  return List.generate(maps.length, (i) {
    return {
      'kagga_id': maps[i]['kagga_id'].toString(),
      'kagga_kn': maps[i]['kagga_kn'],
    };
  });
}

Future<Map<String, Object?>> getKaggaDetails(int kaggaId) async {
  final db = await initializeDatabase();
  final maps =
      await db.query('mankutimma', where: 'kagga_id = ?', whereArgs: [kaggaId]);
  return maps.isNotEmpty ? maps[0] : {};
}
