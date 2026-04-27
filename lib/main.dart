import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'cau_1/apps/app.dart';
import 'cau_2/apps/app.dart';
import 'cau_3/apps/app.dart';
import 'cau_4/apps/app.dart';
import 'cau_5/apps/app.dart';
import 'cau_7/apps/app.dart';
import 'cau_8/apps/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTLT8 - Nguyễn Lộc',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BTLT8 - Nguyễn Lộc (645107043)')),
      body: ListView(
        children: [
          ListTile(title: Text('Câu 1: Ghi chú cơ bản'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau1App()))),
          ListTile(title: Text('Câu 2: Ghi chú có danh mục'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau2App()))),
          ListTile(title: Text('Câu 3: To-do list & JSON'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau3App()))),
          ListTile(title: Text('Câu 4: Quản lý chi tiêu'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau4App()))),
          ListTile(title: Text('Câu 5: Từ điển offline'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau5App()))),
          ListTile(title: Text('Câu 7: Quản lý sinh viên - môn học'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau7App()))),
          ListTile(title: Text('Câu 8: Nhật ký hoạt động'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cau8App()))),
        ],
      ),
    );
  }
}
