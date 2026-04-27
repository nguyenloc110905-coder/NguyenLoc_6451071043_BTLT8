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
                return ListTile(title: Text(note.title), subtitle: Text('$catName - ${note.content}'));
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
