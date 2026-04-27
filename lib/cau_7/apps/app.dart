import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau7App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 7',
      home: StudentScreen(),
    );
  }
}
