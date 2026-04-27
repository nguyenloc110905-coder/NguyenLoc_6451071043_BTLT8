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
