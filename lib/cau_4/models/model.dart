class Cat4 {
  int? id;
  String name;
  Cat4({this.id, required this.name});
  factory Cat4.fromMap(Map<String, dynamic> map) => Cat4(id: map['id'], name: map['name']);
}
class Expense {
  int? id;
  double amount;
  String note;
  int categoryId;
  Expense({this.id, required this.amount, required this.note, required this.categoryId});
  Map<String, dynamic> toMap() => {'id': id, 'amount': amount, 'note': note, 'categoryId': categoryId};
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(id: map['id'], amount: map['amount'], note: map['note'], categoryId: map['categoryId']);
}
