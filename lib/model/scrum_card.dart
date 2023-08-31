import 'dart:convert';
import 'dart:ffi';

class ScrumCard {
  final String? id;
  final String index;
  final String title;
  final String content;
  final String scrumColumn;

  ScrumCard({
    this.id,
    required this.index,
    required this.title,
    required this.content,
    required this.scrumColumn,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'index': index});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'scrumColumn': scrumColumn});

    return result;
  }

  factory ScrumCard.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String index = json['index'];
    String title = json['title'];
    String content = json['content'];
    String scrumColumn = json['scrumColumn'];

    return ScrumCard(
        id: id,
        index: index,
        title: title,
        content: content,
        scrumColumn: scrumColumn);
  }

  String toJson() => json.encode(toMap());
}
