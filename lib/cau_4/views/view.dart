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
          Padding(padding: EdgeInsets.all(8), child: Text('Tổng chi tiêu: $total', style: TextStyle(fontSize: 20))),
          Expanded(
            child: ListView.builder(
              itemCount: exps.length,
              itemBuilder: (c, i) {
                final e = exps[i];
                final catName = cats.firstWhere((c) => c.id == e.categoryId, orElse: () => Cat4(name: '')).name;
                return Card(
                  child: ListTile(
                    title: Text('${e.amount} - $catName'),
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
