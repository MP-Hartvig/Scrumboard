import 'package:scrumboard/model/scrum_card.dart';

enum ScrumCardStates { initial, loading, completed, error }

class ScrumCardState {
  final ScrumCardStates _state;
  final List<ScrumCard> _scrumCards;

  ScrumCardStates get currentState => _state;
  List<ScrumCard> get scrumCards => _scrumCards;

  ScrumCardState({required ScrumCardStates state, List<ScrumCard>? scrumCards})
      : _state = state,
        _scrumCards = scrumCards ?? [];
}