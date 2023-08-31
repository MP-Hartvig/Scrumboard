import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard/api/scrum_card_datahandler_local.dart';
import 'package:scrumboard/event/scrum_event_local.dart';
import 'package:scrumboard/locator/scrum_card_locator.dart';
import 'package:scrumboard/state/scrum_card_local_state.dart';

class CardBlocLocal extends Bloc<ScrumEventLocal, ScrumCardLocalState> {
  CardBlocLocal() : super(ScrumCardLocalState(state: ScrumCardLocalStates.initial)) {
    on<ScrumGetLocalListEvent>(_getScrumLocalListEvent);
    on<ScrumDeleteLocalListEvent>(_deleteScrumLocalListEvent);
  }

  void _getScrumLocalListEvent(
      ScrumEventLocal event, Emitter<ScrumCardLocalState> emit) async {
    emit(ScrumCardLocalState(state: ScrumCardLocalStates.loading));
    final apiService = locator<ScrumCardLocalDataHandler>();

    try {
      final cards = await apiService.getScrumCardLocalCollection();
      emit(ScrumCardLocalState(state: ScrumCardLocalStates.completed, scrumCards: cards));
    } catch (e) {
      emit(ScrumCardLocalState(state: ScrumCardLocalStates.error));
    }
  }

  void _deleteScrumLocalListEvent(
      ScrumEventLocal event, Emitter<ScrumCardLocalState> emit) async {
    emit(ScrumCardLocalState(state: ScrumCardLocalStates.loading));
    final apiService = locator<ScrumCardLocalDataHandler>();

    try {
      await apiService.deleteScrumCardLocalCollection();
      emit(ScrumCardLocalState(state: ScrumCardLocalStates.completed));
    } catch (e) {
      emit(ScrumCardLocalState(state: ScrumCardLocalStates.error));
    }
  }
}
