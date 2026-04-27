import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau4App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 4',
      home: ExpenseScreen(),
    );
  }
}
