class LogItem {
  int? id;
  String action;
  String time;
  LogItem({this.id, required this.action, required this.time});
  factory LogItem.fromMap(Map<String, dynamic> map) => LogItem(id: map['id'], action: map['action'], time: map['time']);
}
