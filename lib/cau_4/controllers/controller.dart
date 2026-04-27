import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/model.dart';

class DBController4 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'exp4.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      await db.execute('CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, note TEXT, categoryId INTEGER)');
      await db.insert('categories', {'name': 'Food'});
      await db.insert('categories', {'name': 'Travel'});
    });
    return _db!;
  }

  static Future<List<Cat4>> getCats() async {
    final d = await db;
    var r = await d.query('categories');
    return r.map((e) => Cat4.fromMap(e)).toList();
  }

  static Future<List<Expense>> getExps() async {
    final d = await db;
    var r = await d.query('expenses');
    return r.map((e) => Expense.fromMap(e)).toList();
  }

  static Future<void> addExp(Expense e) async {
    final d = await db;
    await d.insert('expenses', e.toMap());
  }

  static Future<void> delExp(int id) async {
    final d = await db;
    await d.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
