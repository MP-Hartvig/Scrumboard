import 'dart:convert';

import 'package:appflowy_board/appflowy_board.dart';

class ScrumCard extends AppFlowyGroupItem {
  final String? objectId;
  final String index;
  final String title;
  final String content;
  final String scrumColumn;

  ScrumCard({
    this.objectId,
    required this.index,
    required this.title,
    required this.content,
    required this.scrumColumn,
  });

  @override
  String get id => objectId!;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': objectId});
    result.addAll({'index': index});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'scrumColumn': scrumColumn});

    return result;
  }

  factory ScrumCard.fromMap(Map<String, dynamic> map) {
    return ScrumCard(
      objectId: map['id'] ?? '0',
      index: map['index'] ?? '0',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      scrumColumn: map['scrumColumn'] ?? '0'
    );
  }

  factory ScrumCard.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String index = json['index'];
    String title = json['title'];
    String content = json['content'];
    String scrumColumn = json['scrumColumn'];

    return ScrumCard(
        objectId: id,
        index: index,
        title: title,
        content: content,
        scrumColumn: scrumColumn);
  }

  String toJson() => json.encode(toMap());
}
