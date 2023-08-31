import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard/bloc/card_bloc_local.dart';
import 'package:scrumboard/event/scrum_event_local.dart';
import 'package:scrumboard/model/scrum_card.dart';
import 'package:scrumboard/state/scrum_card_local_state.dart';

class LocalStorageScreen extends StatefulWidget {
  const LocalStorageScreen({super.key});

  @override
  State<LocalStorageScreen> createState() => _LocalStorageScreenState();
}

class _LocalStorageScreenState extends State<LocalStorageScreen> {
  List<ScrumCard> cardList = [];
  @override
  Widget build(BuildContext context) {
    CardBlocLocal cardBlocLocal = BlocProvider.of<CardBlocLocal>(context);
    cardBlocLocal.add(ScrumGetLocalListEvent());
    return Scaffold(
      body: BlocBuilder<CardBlocLocal, ScrumCardLocalState>(
          builder: (BuildContext draggableContext, ScrumCardLocalState state) {
        cardList = state.scrumCards;
        return DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text("Title"),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text("Content"),
              ),
            ),
          ],
          rows: cardList
              .map(
                (ScrumCard card) => DataRow(cells: [
                  DataCell(Text(card.title)),
                  DataCell(
                    Text(card.content),
                  ),
                ]),
              )
              .toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: clearLocalStorage,
          child: const Icon(Icons.delete_forever_outlined)),
    );
  }

  void clearLocalStorage() {
    CardBlocLocal photoBloc = BlocProvider.of<CardBlocLocal>(context);
    photoBloc.add(ScrumDeleteLocalListEvent());
    setState(() {
      cardList = [];
    });
  }
}
