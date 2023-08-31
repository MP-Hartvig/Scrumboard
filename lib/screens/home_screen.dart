import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/custom/board.dart';
import 'package:kanban_board/models/inputs.dart';
import 'package:scrumboard/bloc/card_bloc.dart';
import 'package:scrumboard/event/scrum_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController contentController = TextEditingController();
  late TextEditingController scrumColumnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  final CardBloc cardBloc = BlocProvider.of<CardBloc>(context);
  cardBloc.add(ScrumGetListEvent());
    return KanbanBoard(
      List.generate(
        3,
        (index) => BoardListsData(
          title: getHeader(index),
          width: 250,
          headerBackgroundColor: const Color.fromARGB(255, 235, 236, 240),
          footerBackgroundColor: const Color.fromARGB(255, 235, 236, 240),
          backgroundColor: const Color.fromARGB(255, 235, 236, 240),
          items: List.generate(
            3,
            (index) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  )),
              padding: const EdgeInsets.all(8.0),
              child: Dismissible(
                key: const Key('0'),
                onDismissed: deleteEntry(index),
                background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete_forever_outlined)),
                child: Text(
                  "$index. Lorem ipsum akjwdnakwnd dawnjkda wadnkjawndkjawd awdjnwadnkjwadnwa dwa kajwdakjwd  dwa kjawdkdwk dwakadw kj dwa",
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onItemLongPress: (cardIndex, listIndex) {},
      onItemReorder:
          (oldCardIndex, newCardIndex, oldListIndex, newListIndex) {},
      onItemTap: (cardIndex, listIndex) {},
      backgroundColor: Colors.white,
      displacementY: 124,
      displacementX: 100,
      textStyle: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }

  deleteEntry(int index) {}

  String getHeader(index) {
    if (index == 2) {
      return "Done";
    } else if (index == 1) {
      return "Doing";
    } else {
      return "To do";
    }
  }

  
}
