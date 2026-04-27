import 'dart:io';

void main() {
  final files = {
    // ==========================================
    // CÂU 1: Ghi chú cơ bản
    // ==========================================
    'lib/cau_1/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau1App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 1',
      home: NoteListScreen(),
    );
  }
}
''',
    'lib/cau_1/models/model.dart': '''
class Note {
  int? id;
  String title;
  String content;

  Note({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content};
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], title: map['title'], content: map['content']);
  }
}
''',
    'lib/cau_1/controllers/controller.dart': '''
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
''',
    'lib/cau_1/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  _loadNotes() async {
    notes = await DBController1.getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 1 - Nguyễn Lộc (645107043)')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DBController1.delete(note.id!);
                _loadNotes();
              },
            ),
            onTap: () => _editNote(note),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _editNote(null),
      ),
    );
  }

  _editNote(Note? note) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditScreen(note: note)));
    _loadNotes();
  }
}

class NoteEditScreen extends StatelessWidget {
  final Note? note;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  NoteEditScreen({this.note}) {
    if (note != null) {
      titleController.text = note!.title;
      contentController.text = note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note == null ? 'Thêm Ghi Chú' : 'Sửa Ghi Chú')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: InputDecoration(labelText: 'Content')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final n = Note(id: note?.id, title: titleController.text, content: contentController.text);
                if (note == null) {
                  await DBController1.insert(n);
                } else {
                  await DBController1.update(n);
                }
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            )
          ],
        ),
      ),
    );
  }
}
''',
    // ==========================================
    // CÂU 2: Ghi chú có danh mục
    // ==========================================
    'lib/cau_2/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 2',
      home: NoteListCatScreen(),
    );
  }
}
''',
    'lib/cau_2/models/model.dart': '''
class Category {
  int? id;
  String name;
  Category({this.id, required this.name});
  Map<String, dynamic> toMap() => {'id': id, 'name': name};
  factory Category.fromMap(Map<String, dynamic> map) => Category(id: map['id'], name: map['name']);
}

class Note {
  int? id;
  String title;
  String content;
  int categoryId;
  Note({this.id, required this.title, required this.content, required this.categoryId});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'content': content, 'categoryId': categoryId};
  factory Note.fromMap(Map<String, dynamic> map) => Note(id: map['id'], title: map['title'], content: map['content'], categoryId: map['categoryId']);
}
''',
    'lib/cau_2/controllers/controller.dart': '''
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
''',
    'lib/cau_2/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class NoteListCatScreen extends StatefulWidget {
  @override
  _NoteListCatScreenState createState() => _NoteListCatScreenState();
}

class _NoteListCatScreenState extends State<NoteListCatScreen> {
  List<Note> notes = [];
  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    categories = await DBController2.getCategories();
    notes = await DBController2.getNotes(selectedCategoryId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 2 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          DropdownButton<int>(
            hint: Text('Tất cả'),
            value: selectedCategoryId,
            items: [
              DropdownMenuItem<int>(child: Text('Tất cả'), value: null),
              ...categories.map((c) => DropdownMenuItem<int>(child: Text(c.name), value: c.id)),
            ],
            onChanged: (v) {
              setState(() { selectedCategoryId = v; });
              _loadData();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final catName = categories.firstWhere((c) => c.id == note.categoryId, orElse: () => Category(name: 'N/A')).name;
                return ListTile(title: Text(note.title), subtitle: Text('\$catName - \${note.content}'));
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen(categories)));
          _loadData();
        },
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  final List<Category> categories;
  AddNoteScreen(this.categories);
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  int? catId;

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) catId = widget.categories.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Ghi Chú C2')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: InputDecoration(labelText: 'Content')),
            DropdownButton<int>(
              value: catId,
              items: widget.categories.map((c) => DropdownMenuItem<int>(child: Text(c.name), value: c.id)).toList(),
              onChanged: (v) => setState(() => catId = v),
            ),
            ElevatedButton(
              onPressed: () async {
                if (catId != null) {
                  await DBController2.insertNote(Note(title: titleController.text, content: contentController.text, categoryId: catId!));
                  Navigator.pop(context);
                }
              },
              child: Text('Lưu'),
            )
          ],
        ),
      ),
    );
  }
}
''',
    // ==========================================
    // CÂU 3: To-do list và JSON
    // ==========================================
    'lib/cau_3/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau3App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 3',
      home: TodoScreen(),
    );
  }
}
''',
    'lib/cau_3/models/model.dart': '''
class Task {
  int? id;
  String title;
  int isDone;
  Task({this.id, required this.title, this.isDone = 0});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'isDone': isDone};
  factory Task.fromMap(Map<String, dynamic> map) => Task(id: map['id'], title: map['title'], isDone: map['isDone']);
}
''',
    'lib/cau_3/controllers/controller.dart': '''
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
    final file = File('\${dir.path}/backup.json');
    List<Map<String, dynamic>> jsonData = tasks.map((t) => t.toMap()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<void> importJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('\${dir.path}/backup.json');
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
''',
    'lib/cau_3/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  final tc = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    tasks = await DBController3.getTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 3 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: tc, decoration: InputDecoration(hintText: 'Thêm task...'))),
              IconButton(icon: Icon(Icons.add), onPressed: () async {
                if (tc.text.isNotEmpty) {
                  await DBController3.insert(Task(title: tc.text));
                  tc.clear();
                  _load();
                }
              })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () async { await DBController3.exportJson(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported!'))); }, child: Text('Export')),
              ElevatedButton(onPressed: () async { await DBController3.importJson(); _load(); }, child: Text('Import')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final t = tasks[index];
                return CheckboxListTile(
                  title: Text(t.title),
                  value: t.isDone == 1,
                  onChanged: (val) async {
                    t.isDone = val! ? 1 : 0;
                    await DBController3.update(t);
                    _load();
                  },
                  secondary: IconButton(icon: Icon(Icons.delete), onPressed: () async {
                    await DBController3.delete(t.id!);
                    _load();
                  }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
''',
    // ==========================================
    // CÂU 4: Quản lý chi tiêu
    // ==========================================
    'lib/cau_4/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau4App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 4',
      home: ExpenseScreen(),
    );
  }
}
''',
    'lib/cau_4/models/model.dart': '''
class Cat4 {
  int? id;
  String name;
  Cat4({this.id, required this.name});
  factory Cat4.fromMap(Map<String, dynamic> map) => Cat4(id: map['id'], name: map['name']);
}
class Expense {
  int? id;
  double amount;
  String note;
  int categoryId;
  Expense({this.id, required this.amount, required this.note, required this.categoryId});
  Map<String, dynamic> toMap() => {'id': id, 'amount': amount, 'note': note, 'categoryId': categoryId};
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(id: map['id'], amount: map['amount'], note: map['note'], categoryId: map['categoryId']);
}
''',
    'lib/cau_4/controllers/controller.dart': '''
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
''',
    'lib/cau_4/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<Expense> exps = [];
  List<Cat4> cats = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    cats = await DBController4.getCats();
    exps = await DBController4.getExps();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double total = exps.fold(0, (sum, item) => sum + item.amount);
    return Scaffold(
      appBar: AppBar(title: Text('Câu 4 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8), child: Text('Tổng chi tiêu: \$total', style: TextStyle(fontSize: 20))),
          Expanded(
            child: ListView.builder(
              itemCount: exps.length,
              itemBuilder: (c, i) {
                final e = exps[i];
                final catName = cats.firstWhere((c) => c.id == e.categoryId, orElse: () => Cat4(name: '')).name;
                return Card(
                  child: ListTile(
                    title: Text('\${e.amount} - \$catName'),
                    subtitle: Text(e.note),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () async {
                      await DBController4.delExp(e.id!);
                      _load();
                    }),
                  )
                );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addExpDialog(),
      ),
    );
  }

  _addExpDialog() {
    final amt = TextEditingController();
    final note = TextEditingController();
    int? cId = cats.isNotEmpty ? cats.first.id : null;
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text('Thêm chi tiêu'),
      content: StatefulBuilder(builder: (c, setS) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: amt, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Số tiền')),
          TextField(controller: note, decoration: InputDecoration(labelText: 'Ghi chú')),
          DropdownButton<int>(
            value: cId,
            items: cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => setS(() => cId = v),
          )
        ]
      )),
      actions: [
        ElevatedButton(onPressed: () async {
          await DBController4.addExp(Expense(amount: double.parse(amt.text), note: note.text, categoryId: cId!));
          Navigator.pop(ctx);
          _load();
        }, child: Text('Lưu'))
      ],
    ));
  }
}
''',
    // ==========================================
    // CÂU 5: Từ điển offline
    // ==========================================
    'lib/cau_5/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau5App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 5',
      home: DictScreen(),
    );
  }
}
''',
    'lib/cau_5/models/model.dart': '''
class DictItem {
  int? id;
  String word;
  String meaning;
  DictItem({this.id, required this.word, required this.meaning});
  Map<String, dynamic> toMap() => {'id': id, 'word': word, 'meaning': meaning};
  factory DictItem.fromMap(Map<String, dynamic> map) => DictItem(id: map['id'], word: map['word'], meaning: map['meaning']);
}
''',
    'lib/cau_5/controllers/controller.dart': '''
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
    var r = await d.query('dictionary', where: 'word LIKE ?', whereArgs: ['%\$q%']);
    return r.map((e) => DictItem.fromMap(e)).toList();
  }
}
''',
    'lib/cau_5/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class DictScreen extends StatefulWidget {
  @override
  _DictScreenState createState() => _DictScreenState();
}

class _DictScreenState extends State<DictScreen> {
  List<DictItem> res = [];
  final tc = TextEditingController();

  _search(String q) async {
    if (q.isEmpty) {
      setState(() => res = []);
      return;
    }
    res = await DBController5.search(q);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 5 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: tc,
              decoration: InputDecoration(labelText: 'Tìm kiếm từ...'),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: res.length,
              itemBuilder: (c, i) => ListTile(title: Text(res[i].word), subtitle: Text(res[i].meaning))
            )
          )
        ],
      )
    );
  }
}
''',
    // ==========================================
    // CÂU 7: Quản lý sinh viên - môn học
    // ==========================================
    'lib/cau_7/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau7App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 7',
      home: StudentScreen(),
    );
  }
}
''',
    'lib/cau_7/models/model.dart': '''
class Student {
  int? id;
  String name;
  Student({this.id, required this.name});
  factory Student.fromMap(Map<String, dynamic> map) => Student(id: map['id'], name: map['name']);
}
class Course {
  int? id;
  String name;
  Course({this.id, required this.name});
  factory Course.fromMap(Map<String, dynamic> map) => Course(id: map['id'], name: map['name']);
}
''',
    'lib/cau_7/controllers/controller.dart': '''
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
''',
    'lib/cau_7/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Student> stds = [];
  List<Course> courses = [];
  Student? selStd;
  List<Course> stdCourses = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    stds = await DBController7.getStds();
    courses = await DBController7.getCourses();
    if (selStd != null) stdCourses = await DBController7.getStdCourses(selStd!.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 7 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          DropdownButton<Student>(
            value: selStd,
            hint: Text('Chọn sinh viên'),
            items: stds.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
            onChanged: (s) {
              setState(() => selStd = s);
              _load();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (c, i) {
                final cse = courses[i];
                bool isEnrolled = stdCourses.any((sc) => sc.id == cse.id);
                return CheckboxListTile(
                  title: Text(cse.name),
                  value: isEnrolled,
                  onChanged: (val) async {
                    if (val == true && selStd != null) {
                      await DBController7.enroll(selStd!.id!, cse.id!);
                      _load();
                    }
                  }
                );
              }
            )
          )
        ],
      )
    );
  }
}
''',
    // ==========================================
    // CÂU 8: Nhật ký hoạt động
    // ==========================================
    'lib/cau_8/apps/app.dart': '''
import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau8App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 8',
      home: LogScreen(),
    );
  }
}
''',
    'lib/cau_8/models/model.dart': '''
class LogItem {
  int? id;
  String action;
  String time;
  LogItem({this.id, required this.action, required this.time});
  factory LogItem.fromMap(Map<String, dynamic> map) => LogItem(id: map['id'], action: map['action'], time: map['time']);
}
''',
    'lib/cau_8/controllers/controller.dart': '''
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
    final file = File('\${dir.path}/log.txt');
    await file.writeAsString('\$t: \$action\\n', mode: FileMode.append);
  }

  static Future<List<LogItem>> getLogs() async {
    final d = await db;
    var r = await d.query('logs');
    return r.map((e) => LogItem.fromMap(e)).toList();
  }
}
''',
    'lib/cau_8/views/view.dart': '''
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../controllers/controller.dart';

class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<LogItem> logs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    logs = await DBController8.getLogs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 8 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () async { await DBController8.addLog('ADD'); _load(); }, child: Text('Add')),
              ElevatedButton(onPressed: () async { await DBController8.addLog('UPDATE'); _load(); }, child: Text('Update')),
              ElevatedButton(onPressed: () async { await DBController8.addLog('DELETE'); _load(); }, child: Text('Delete')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (c, i) => ListTile(title: Text(logs[i].action), subtitle: Text(logs[i].time))
            )
          )
        ],
      )
    );
  }
}
''',
    // ==========================================
    // MAIN ENTRY POINT
    // ==========================================
    'lib/main.dart': '''
import 'package:flutter/material.dart';
import 'cau_1/apps/app.dart';
import 'cau_2/apps/app.dart';
import 'cau_3/apps/app.dart';
import 'cau_4/apps/app.dart';
import 'cau_5/apps/app.dart';
import 'cau_7/apps/app.dart';
import 'cau_8/apps/app.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTLT8 - Nguyễn Lộc',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BTLT8 - Nguyễn Lộc (645107043)')),
      body: ListView(
        children: [
          ListTile(title: Text('Câu 1: Ghi chú cơ bản'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau1App()))),
          ListTile(title: Text('Câu 2: Ghi chú có danh mục'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau2App()))),
          ListTile(title: Text('Câu 3: To-do list & JSON'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau3App()))),
          ListTile(title: Text('Câu 4: Quản lý chi tiêu'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau4App()))),
          ListTile(title: Text('Câu 5: Từ điển offline'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau5App()))),
          ListTile(title: Text('Câu 7: Quản lý sinh viên - môn học'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau7App()))),
          ListTile(title: Text('Câu 8: Nhật ký hoạt động'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau8App()))),
        ],
      ),
    );
  }
}
'''
  };

  files.forEach((path, content) {
    File(path).writeAsStringSync(content);
    print('Created \$path');
  });
}
