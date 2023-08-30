import 'package:flutter/material.dart';
import 'package:kanban_board/custom/board.dart';
import 'package:kanban_board/models/inputs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: ScrumWidget(),
          ),
        ),
      ),
    );
  }
}

class ScrumWidget extends StatefulWidget {
  const ScrumWidget({super.key});

  @override
  State<ScrumWidget> createState() => _ScrumWidgetState();
}

class _ScrumWidgetState extends State<ScrumWidget> {
  @override
  Widget build(BuildContext context) {
    return KanbanBoard(
      List.generate(
        3,
        (index) => BoardListsData(
          title: getHeader(index),
          width: 250,
          headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
          footerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
          backgroundColor: Color.fromARGB(255, 235, 236, 240),
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
