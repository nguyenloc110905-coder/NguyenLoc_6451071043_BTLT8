import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/model.dart';

class DBController7 {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'student7.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      await db.execute('CREATE TABLE courses(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      await db.execute('CREATE TABLE enrollments(id INTEGER PRIMARY KEY AUTOINCREMENT, studentId INTEGER, courseId INTEGER)');
      await db.insert('students', {'name': 'Nguyen Loc'});
      await db.insert('courses', {'name': 'Toan'});
      await db.insert('courses', {'name': 'Ly'});
    });
    return _db!;
  }

  static Future<List<Student>> getStds() async {
    final d = await db;
    var r = await d.query('students');
    return r.map((e) => Student.fromMap(e)).toList();
  }
  static Future<List<Course>> getCourses() async {
    final d = await db;
    var r = await d.query('courses');
    return r.map((e) => Course.fromMap(e)).toList();
  }
  static Future<List<Course>> getStdCourses(int stdId) async {
    final d = await db;
    var r = await d.rawQuery('SELECT c.* FROM courses c INNER JOIN enrollments e ON c.id = e.courseId WHERE e.studentId = ?', [stdId]);
    return r.map((e) => Course.fromMap(e)).toList();
  }
  static Future<void> enroll(int sId, int cId) async {
    final d = await db;
    await d.insert('enrollments', {'studentId': sId, 'courseId': cId});
  }
}
