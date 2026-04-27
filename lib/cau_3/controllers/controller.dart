import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/model.dart';

class DBController3 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'todo3.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isDone INTEGER)');
    });
  }

  static Future<List<Task>> getTasks() async {
    final dbClient = await db;
    var res = await dbClient.query('tasks');
    return res.map((e) => Task.fromMap(e)).toList();
  }

  static Future<int> insert(Task task) async {
    final dbClient = await db;
    return await dbClient.insert('tasks', task.toMap());
  }

  static Future<int> update(Task task) async {
    final dbClient = await db;
    return await dbClient.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> delete(int id) async {
    final dbClient = await db;
    return await dbClient.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> exportJson() async {
    final tasks = await getTasks();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/backup.json');
    List<Map<String, dynamic>> jsonData = tasks.map((t) => t.toMap()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<void> importJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/backup.json');
    if (await file.exists()) {
      String data = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(data);
      final dbClient = await db;
      await dbClient.delete('tasks');
      for (var item in jsonList) {
        await dbClient.insert('tasks', item);
      }
    }
  }
}
