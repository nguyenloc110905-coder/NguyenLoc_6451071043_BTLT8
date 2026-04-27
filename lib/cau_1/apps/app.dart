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
