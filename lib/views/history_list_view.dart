import 'package:flutter/material.dart';
import 'package:shopping_list_task/service/shopping_item.dart';
import 'package:shopping_list_task/utils/app_layout.dart';

import '../cubits/history_list_cubit/history_cubit_state.dart';

typedef NoteCallback = void Function(ShoppingList item);

class HistoryListView extends StatelessWidget {
  final EditingHistoryListState state;
  final NoteCallback deleteItem;
  final NoteCallback onTap;

  const HistoryListView(
      {Key? key,
      required this.state,
      required this.deleteItem,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: AppLayout.getHeight(10)),
        child: (Row(
          children: [
            GestureDetector(
              onTap: () {
                onTap(state.currentList[index]);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    state.currentList[index].createdAt,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppLayout.getWidth(5)),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteItem(state.currentList[index]);
                },
              ),
            ),
          ],
        )),
      ),
      itemCount: state.currentList.length,
    );
  }
}
