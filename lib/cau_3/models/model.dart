class Task {
  int? id;
  String title;
  int isDone;
  Task({this.id, required this.title, this.isDone = 0});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'isDone': isDone};
  factory Task.fromMap(Map<String, dynamic> map) => Task(id: map['id'], title: map['title'], isDone: map['isDone']);
}
