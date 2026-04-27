import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/model.dart';

class DBController5 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'dict5.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE dictionary(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, meaning TEXT)');
      // Insert initial
      await db.insert('dictionary', {'word': 'hello', 'meaning': 'xin chào'});
      await db.insert('dictionary', {'word': 'world', 'meaning': 'thế giới'});
    });
    return _db!;
  }

  static Future<List<DictItem>> search(String q) async {
    final d = await db;
    var r = await d.query('dictionary', where: 'word LIKE ?', whereArgs: ['%$q%']);
    return r.map((e) => DictItem.fromMap(e)).toList();
  }
}
