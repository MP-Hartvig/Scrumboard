import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:scrumboard/model/app_flowy_model.dart';
import 'package:scrumboard/model/scrum_card.dart';
import 'package:scrumboard/model/scrum_card_list.dart';

class ScrumBoard extends StatefulWidget {
  const ScrumBoard({super.key});

  @override
  State<ScrumBoard> createState() => _ScrumBoardState();
}

class _ScrumBoardState extends State<ScrumBoard> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController contentController = TextEditingController();
  late TextEditingController scrumColumnController = TextEditingController();
  List<ScrumCardList> scrumCardParentList = [];
  List<ScrumCard> todo = [];
  List<ScrumCard> doing = [];
  List<ScrumCard> done = [];
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  late AppFlowyBoardScrollController boardController;

  @override
  void initState() {
    boardController = AppFlowyBoardScrollController();
    final group1 =
        AppFlowyGroupData(id: "todo", name: "To do", items: [...todo]);

    final group2 = AppFlowyGroupData(
      id: "doing",
      name: "In progress",
      items: <AppFlowyGroupItem>[...doing],
    );

    final group3 = AppFlowyGroupData(
        id: "done", name: "Done", items: <AppFlowyGroupItem>[...done]);

    controller.addGroup(group1);
    controller.addGroup(group2);
    controller.addGroup(group3);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const config = AppFlowyBoardConfig(
      groupBackgroundColor: Colors.lightBlue,
      stretchGroupHeight: false,
    );
    return AppFlowyBoard(
        controller: controller,
        cardBuilder: (context, group, groupItem) {
          return AppFlowyGroupCard(
            key: ValueKey(groupItem.id),
            child: _buildCard(groupItem),
          );
        },
        boardScrollController: boardController,
        footerBuilder: (context, columnData) {
          return AppFlowyGroupFooter(
            icon: const Icon(Icons.add, size: 20),
            title: const Text('New'),
            height: 50,
            margin: config.groupItemPadding,
            onAddButtonClick: () {
              boardController.scrollToBottom(columnData.id);
            },
          );
        },
        headerBuilder: (context, columnData) {
          return AppFlowyGroupHeader(
            icon: const Icon(Icons.lightbulb_circle),
            title: SizedBox(
              width: 60,
              child: TextField(
                controller: TextEditingController()
                  ..text = columnData.headerData.groupName,
                onSubmitted: (val) {
                  controller
                      .getGroupController(columnData.headerData.groupId)!
                      .updateGroupName(val);
                },
              ),
            ),
            addIcon: const Icon(Icons.add, size: 20),
            moreIcon: const Icon(Icons.more_horiz, size: 20),
            height: 50,
            margin: config.groupItemPadding,
          );
        },
        groupConstraints: const BoxConstraints.tightFor(width: 240),
        config: config);
  }

  setScrumContent(List<ScrumCard> scrumCards) {
    for (var i = 0; i < scrumCards.length; i++) {
      if (scrumCards[i].scrumColumn == '0') {
        todo.add(scrumCards[i]);
      } else if (scrumCards[i].scrumColumn == '1') {
        doing.add(scrumCards[i]);
      } else {
        done.add(scrumCards[i]);
      }
    }

    // ScrumCardList todoList = ScrumCardList(scrumCardList: todo);
    // ScrumCardList doingList = ScrumCardList(scrumCardList: doing);
    // ScrumCardList doneList = ScrumCardList(scrumCardList: done);

    // scrumCardParentList.add(todoList);
    // scrumCardParentList.add(doingList);
    // scrumCardParentList.add(doneList);
  }

  Widget _buildCard(AppFlowyGroupItem item) {
    if (item is ScrumCard) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Center(
                    child: Text(item.title),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    item.content,
                    softWrap: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }
}
