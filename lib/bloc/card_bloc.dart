import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard/api/scrum_card_datahandler.dart';
import 'package:scrumboard/event/scrum_event.dart';
import 'package:scrumboard/locator/scrum_card_locator.dart';
import 'package:scrumboard/state/scrum_card_state.dart';

class CardBloc extends Bloc<ScrumEvent, ScrumCardState> {
  CardBloc() : super(ScrumCardState(state: ScrumCardStates.initial)) {
    on<ScrumGetListEvent>(_getScrumCardListEvent);
    on<ScrumCreateEvent>(_postScrumEvent);
    on<ScrumLoginEvent>(_postLoginEvent);
    on<ScrumUpdateEvent>(_putScrumEvent);
    on<ScrumDeleteEvent>(_deleteScrumEvent);
  }

  void _getScrumCardListEvent(
      ScrumEvent event, Emitter<ScrumCardState> emit) async {
    emit(ScrumCardState(state: ScrumCardStates.loading));
    final apiService = locator<ScrumCardDataHandler>();

    try {
      final cards = await apiService.getScrumCardCollection();
      emit(ScrumCardState(state: ScrumCardStates.completed, scrumCards: cards));
    } catch (e) {
      emit(ScrumCardState(state: ScrumCardStates.error));
    }
  }

  void _postScrumEvent(
      ScrumCreateEvent event, Emitter<ScrumCardState> emit) async {
    emit(ScrumCardState(state: ScrumCardStates.loading));
    final apiService = locator<ScrumCardDataHandler>();

    try {
      await apiService.postScrumCard(event.scrumCard);
      emit(ScrumCardState(state: ScrumCardStates.completed));
    } catch (e) {
      emit(ScrumCardState(state: ScrumCardStates.error));
    }
  }

  void _postLoginEvent(
      ScrumLoginEvent event, Emitter<ScrumCardState> emit) async {
    emit(ScrumCardState(state: ScrumCardStates.loading));
    final apiService = locator<ScrumCardDataHandler>();

    try {
      await apiService.postLogin(event.login);
    } catch (e) {
      emit(ScrumCardState(state: ScrumCardStates.error));
    }
  }

  void _putScrumEvent(
      ScrumUpdateEvent event, Emitter<ScrumCardState> emit) async {
    emit(ScrumCardState(state: ScrumCardStates.loading));
    final apiService = locator<ScrumCardDataHandler>();

    try {
      await apiService.putScrumCard(event.scrumCard);
    } catch (e) {
      emit(ScrumCardState(state: ScrumCardStates.error));
    }
  }

  void _deleteScrumEvent(
      ScrumDeleteEvent event, Emitter<ScrumCardState> emit) async {
    emit(ScrumCardState(state: ScrumCardStates.loading));
    final apiService = locator<ScrumCardDataHandler>();

    try {
      await apiService.deleteScrumCard(event.scrumCard);
    } catch (e) {
      emit(ScrumCardState(state: ScrumCardStates.error));
    }
  }
}
