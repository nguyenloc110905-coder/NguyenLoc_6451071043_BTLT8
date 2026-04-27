import 'package:flutter/material.dart';
import '../views/view.dart';

class Cau5App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cau 5',
      home: DictScreen(),
    );
  }
}
