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
