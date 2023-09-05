import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrumboard/model/scrum_card.dart';

void main() {
  group('Testing scrum card model', () {
    test('Scrum card to map', () {
      var card = ScrumCard(
          objectId: '12345678',
          index: '0',
          title: 'Test title',
          content: 'Test content',
          scrumColumn: '0');
      var map = card.toMap();
      expect(map, isNotNull);
      expect(map['id'], '12345678');
      expect(map['index'], isA<String>());
      expect(map['title'], isA<String>());
      expect(map['content'], 'Test content');
      expect(map['scrumColumn'], '0');
    });

    test('Scrum card from map', () {
      var card = ScrumCard.fromMap(createRandomCardData());
      expect(card, isNotNull);
      expect(card.objectId, isA<String>());
      expect(card.title, 'Test title');
    });

    test('Scrum card to JSON', () {
      var card = ScrumCard.fromMap(createRandomCardData());
      var jsonObj = card.toJson();
      expect(jsonObj, isNotNull);
      var json = jsonDecode(jsonObj);
      expect(json, isNotNull);
      expect(json['id'], '12345678');
    });
  });
}

Map<String, dynamic> createRandomCardData() {
  var map = <String, dynamic>{};
  map.addAll({'id': '12345678'});
  map.addAll({'index': '0'});
  map.addAll({'title': 'Test title'});
  map.addAll({'content': 'Test content'});
  map.addAll({'scrumColumn': '0'});
  return map;
}