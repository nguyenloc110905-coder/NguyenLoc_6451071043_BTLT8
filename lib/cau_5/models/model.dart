class DictItem {
  int? id;
  String word;
  String meaning;
  DictItem({this.id, required this.word, required this.meaning});
  Map<String, dynamic> toMap() => {'id': id, 'word': word, 'meaning': meaning};
  factory DictItem.fromMap(Map<String, dynamic> map) => DictItem(id: map['id'], word: map['word'], meaning: map['meaning']);
}
