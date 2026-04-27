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
