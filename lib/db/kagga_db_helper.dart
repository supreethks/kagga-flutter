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
  }

  // Open the database
  final db = await openDatabase(path);

  // Create index for faster search
  await db.execute(
    'CREATE INDEX IF NOT EXISTS idx_kagga_search ON mankutimma(kagga_latn COLLATE NOCASE)',
  );

  return db;
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

Stream<List<Map<String, dynamic>>> searchKaggaProgressive(String query,
    {Set<String>? favorites}) async* {
  final db = await initializeDatabase();

  // Yield exact matches immediately
  final exactResults = await _searchWithQuery(db, query, favorites);
  yield exactResults;

  // Get fuzzy matches and yield combined results
  var allResults = List<Map<String, dynamic>>.from(exactResults);
  final variations = _getCommonVariations(query);

  for (final variation in variations) {
    var variationResults = await _searchWithQuery(db, variation, favorites);
    // Filter out results that are already found
    variationResults.removeWhere((fuzzyResult) => allResults
        .any((result) => result['kagga_id'] == fuzzyResult['kagga_id']));

    if (variationResults.isNotEmpty) {
      allResults.addAll(variationResults);
      yield allResults;
    }
  }
}

Future<List<Map<String, dynamic>>> _searchWithQuery(
    Database db, String query, Set<String>? favorites) async {
  var whereClause =
      '(kagga_latn LIKE ? COLLATE NOCASE OR kagga_kn LIKE ? COLLATE NOCASE)';
  var whereArgs = ['%$query%', '%$query%'];

  if (favorites != null && favorites.isNotEmpty) {
    whereClause +=
        ' AND kagga_id IN (${List.filled(favorites.length, '?').join(',')})';
    whereArgs.addAll(favorites.toList());
  }

  final List<Map<String, dynamic>> maps = await db.query(
    'mankutimma',
    columns: ['kagga_id', 'kagga_kn'],
    where: whereClause,
    whereArgs: whereArgs,
  );

  return List.generate(maps.length, (i) {
    return {
      'kagga_id': maps[i]['kagga_id'].toString(),
      'kagga_kn': maps[i]['kagga_kn'],
    };
  });
}

List<String> _getCommonVariations(String query) {
  // Only most common Kannada transliteration variations
  final commonReplacements = {
    'ee': 'i',
    'i': 'ee',
    'oo': 'u',
    'u': 'oo',
    'v': 'w',
    'w': 'v',
  };

  final variations = <String>[];
  String temp = query.toLowerCase();

  for (var entry in commonReplacements.entries) {
    if (temp.contains(entry.key)) {
      variations.add(temp.replaceAll(entry.key, entry.value));
    }
  }

  return variations;
}
