import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau8App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 8',
      home: LogScreen(),
    );
  }
}
