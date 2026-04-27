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
