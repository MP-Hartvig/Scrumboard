import 'package:appflowy_board/appflowy_board.dart';

class ScrumCardItem extends AppFlowyGroupItem {
  final String objectId;
  final String title;
  final String content;
  final String scrumColumn;

  ScrumCardItem(
      {required this.objectId,
      required this.title,
      required this.content,
      required this.scrumColumn});

  @override
  String get id => objectId;
}
