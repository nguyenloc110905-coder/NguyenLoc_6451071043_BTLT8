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
  int? selStdId;
  List<Course> stdCourses = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    stds = await DBController7.getStds();
    courses = await DBController7.getCourses();
    if (selStdId != null) stdCourses = await DBController7.getStdCourses(selStdId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Câu 7 - Nguyễn Lộc (645107043)')),
      body: Column(
        children: [
          DropdownButton<int>(
            value: selStdId,
            hint: Text('Chọn sinh viên'),
            items: stds.map((s) => DropdownMenuItem<int>(value: s.id, child: Text(s.name))).toList(),
            onChanged: (v) {
              setState(() => selStdId = v);
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
                    if (val == true && selStdId != null) {
                      await DBController7.enroll(selStdId!, cse.id!);
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
