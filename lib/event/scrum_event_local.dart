import 'package:scrumboard/model/scrum_card.dart';

abstract class ScrumEventLocal {}

class ScrumGetLocalListEvent implements ScrumEventLocal {}

class ScrumDeleteLocalListEvent implements ScrumEventLocal {}

class ScrumCreateLocalEvent implements ScrumEventLocal {
  final ScrumCard _scrumCard;

  ScrumCard get scrumCard => _scrumCard;

  ScrumCreateLocalEvent(this._scrumCard);
}
