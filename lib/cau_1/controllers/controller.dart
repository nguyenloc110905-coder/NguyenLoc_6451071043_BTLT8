import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/model.dart';

class DBController1 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'notes1.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)');
    });
  }

  static Future<int> insert(Note note) async {
    final dbClient = await db;
    return await dbClient.insert('notes', note.toMap());
  }

  static Future<List<Note>> getNotes() async {
    final dbClient = await db;
    var res = await dbClient.query('notes');
    return res.map((e) => Note.fromMap(e)).toList();
  }

  static Future<int> update(Note note) async {
    final dbClient = await db;
    return await dbClient.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<int> delete(int id) async {
    final dbClient = await db;
    return await dbClient.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
