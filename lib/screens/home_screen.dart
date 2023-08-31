import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/custom/board.dart';
import 'package:kanban_board/models/inputs.dart';
import 'package:scrumboard/bloc/card_bloc.dart';
import 'package:scrumboard/event/scrum_event.dart';
import 'package:scrumboard/model/scrum_card.dart';
import 'package:scrumboard/model/scrum_card_list.dart';
import 'package:scrumboard/state/scrum_card_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController contentController = TextEditingController();
  late TextEditingController scrumColumnController = TextEditingController();
  List<ScrumCardList> scrumCardParentList = [];
  List<ScrumCard> todo = [];
  List<ScrumCard> doing = [];
  List<ScrumCard> done = [];

  @override
  Widget build(BuildContext context) {
    List<ScrumCard> cardList = [];
    final CardBloc cardBloc = BlocProvider.of<CardBloc>(context);
    cardBloc.add(ScrumGetListEvent());
    return Scaffold(
      body: BlocBuilder<CardBloc, ScrumCardState>(
        builder: (BuildContext kanbanContext, ScrumCardState state) {
          cardList = state.scrumCards;
          setKanbanContent(cardList);
          return KanbanBoard(
            getBoardListsData(),
            // onItemLongPress: (cardIndex, listIndex) {
            // },
            onItemTap: (cardIndex, listIndex) {
              deleteEntryDialog(cardIndex!, listIndex!);
            },
            onItemReorder:
                (oldCardIndex, newCardIndex, oldListIndex, newListIndex) {
              ScrumCard scrumCard = scrumCardParentList[oldListIndex!]
                  .scrumCardList
                  .removeAt(oldCardIndex!);

              scrumCardParentList[newListIndex!]
                  .scrumCardList
                  .insert(newCardIndex!, scrumCard);
            },
            backgroundColor: Colors.white,
            displacementY: 124,
            displacementX: 100,
          );
        },
      ),
    );
  }

  setKanbanContent(List<ScrumCard> scrumCards) {
    for (var i = 0; i < scrumCards.length; i++) {
      if (scrumCards[i].scrumColumn == '0') {
        todo.add(scrumCards[i]);
      } else if (scrumCards[i].scrumColumn == '1') {
        doing.add(scrumCards[i]);
      } else {
        done.add(scrumCards[i]);
      }
    }

    ScrumCardList todoList = ScrumCardList(scrumCardList: todo);
    ScrumCardList doingList = ScrumCardList(scrumCardList: doing);
    ScrumCardList doneList = ScrumCardList(scrumCardList: done);

    scrumCardParentList.add(todoList);
    scrumCardParentList.add(doingList);
    scrumCardParentList.add(doneList);
  }

  List<BoardListsData> getBoardListsData() {
    return List.generate(
      3,
      (index) => BoardListsData(
        title: getTitle(index),
        header: Container(),
        footer: Container(),
        width: 250,
        headerBackgroundColor: const Color.fromARGB(255, 163, 177, 236),
        footerBackgroundColor: const Color.fromARGB(255, 163, 177, 236),
        backgroundColor: const Color.fromARGB(255, 157, 164, 192),
        items: getScrumCardsRedirector(index),
      ),
    );
  }

  String getTitle(index) {
    if (index == 0) {
      return "To do";
    } else if (index == 1) {
      return "Doing";
    } else {
      return "Done";
    }
  }

  List<Widget> getScrumCardsRedirector(int parentIndex) {
    List<Widget> scrumCardWidgets = [];

    if (parentIndex == 0) {
      scrumCardWidgets = getScrumCards(scrumCardParentList[0].scrumCardList);
    } else if (parentIndex == 1) {
      scrumCardWidgets = getScrumCards(scrumCardParentList[1].scrumCardList);
    } else {
      scrumCardWidgets = getScrumCards(scrumCardParentList[2].scrumCardList);
    }

    return scrumCardWidgets;
  }

  List<Widget> getScrumCards(List<ScrumCard> scrumCards) {
    return List.generate(
      scrumCards.length,
      (index) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                scrumCards[index].title,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              scrumCards[index].content,
              softWrap: true,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteEntryDialog(int cardIndex, int listIndex) {
    final CardBloc cardBloc = BlocProvider.of<CardBloc>(context);
    return AlertDialog(
      title: const Text('Are you sure you want to delete?'),
      actions: <Widget>[
        BlocBuilder<CardBloc, ScrumCardState>(
          builder: (BuildContext deleteContext, ScrumCardState state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () => {
                    cardBloc.add(
                      ScrumDeleteEvent(
                        scrumCardParentList[listIndex]
                            .scrumCardList
                            .removeAt(listIndex),
                      ),
                    ),
                    setState(() {})
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}