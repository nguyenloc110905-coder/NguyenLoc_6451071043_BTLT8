import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/model.dart';

class DBController2 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'notes2.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      await db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, categoryId INTEGER)');
      await db.insert('categories', {'name': 'Work'});
      await db.insert('categories', {'name': 'Personal'});
    });
  }

  static Future<List<Category>> getCategories() async {
    final dbClient = await db;
    var res = await dbClient.query('categories');
    return res.map((e) => Category.fromMap(e)).toList();
  }

  static Future<List<Note>> getNotes(int? categoryId) async {
    final dbClient = await db;
    List<Map<String, Object?>> res;
    if (categoryId == null) {
      res = await dbClient.query('notes');
    } else {
      res = await dbClient.query('notes', where: 'categoryId = ?', whereArgs: [categoryId]);
    }
    return res.map((e) => Note.fromMap(e)).toList();
  }

  static Future<int> insertNote(Note note) async {
    final dbClient = await db;
    return await dbClient.insert('notes', note.toMap());
  }
}
