import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/model.dart';

class DBController8 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'log8.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, action TEXT, time TEXT)');
    });
    return _db!;
  }

  static Future<void> addLog(String action) async {
    final d = await db;
    String t = DateTime.now().toString();
    await d.insert('logs', {'action': action, 'time': t});
    
    // Write to file
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/log.txt');
    await file.writeAsString('$t: $action\n', mode: FileMode.append);
  }

  static Future<List<LogItem>> getLogs() async {
    final d = await db;
    var r = await d.query('logs');
    return r.map((e) => LogItem.fromMap(e)).toList();
  }
}
