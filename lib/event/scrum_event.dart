import 'package:scrumboard/model/login.dart';
import 'package:scrumboard/model/scrum_card.dart';

abstract class ScrumEvent {}

class ScrumLoginEvent implements ScrumEvent {
  final Login _login;

  Login get login => _login;

  ScrumLoginEvent(this._login);
}

class ScrumGetListEvent implements ScrumEvent {}

class ScrumCreateEvent implements ScrumEvent {
  final ScrumCard _scrumCard;

  ScrumCard get scrumCard => _scrumCard;

  ScrumCreateEvent(this._scrumCard);
}

class ScrumUpdateEvent implements ScrumEvent {
  final ScrumCard _scrumCard;

  ScrumCard get scrumCard => _scrumCard;

  ScrumUpdateEvent(this._scrumCard);
}

class ScrumDeleteEvent implements ScrumEvent {
  final ScrumCard _scrumCard;

  ScrumCard get scrumCard => _scrumCard;

  ScrumDeleteEvent(this._scrumCard);
}
