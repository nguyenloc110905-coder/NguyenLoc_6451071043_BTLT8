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
