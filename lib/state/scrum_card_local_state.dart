import 'package:scrumboard/model/scrum_card.dart';

enum ScrumCardLocalStates { initial, loading, completed, error }

class ScrumCardLocalState {
  final ScrumCardLocalStates _state;
  final List<ScrumCard> _scrumCards;

  ScrumCardLocalStates get currentState => _state;
  List<ScrumCard> get scrumCards => _scrumCards;

  ScrumCardLocalState({required ScrumCardLocalStates state, List<ScrumCard>? scrumCards})
      : _state = state,
        _scrumCards = scrumCards ?? [];
}