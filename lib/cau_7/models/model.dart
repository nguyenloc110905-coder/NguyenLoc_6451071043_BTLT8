class Student {
  int? id;
  String name;
  Student({this.id, required this.name});
  factory Student.fromMap(Map<String, dynamic> map) => Student(id: map['id'], name: map['name']);
}
class Course {
  int? id;
  String name;
  Course({this.id, required this.name});
  factory Course.fromMap(Map<String, dynamic> map) => Course(id: map['id'], name: map['name']);
}
