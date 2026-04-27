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
