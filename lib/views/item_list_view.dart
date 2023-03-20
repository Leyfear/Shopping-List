import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopping_list_task/service/shopping_item.dart';

import '../cubits/shopping_list_cubit/list_cubit_state.dart';
import '../utils/app_layout.dart';


typedef NoteCallback = void Function(ShoppingItem item);

class ItemListView extends StatelessWidget {
  final EditCurrentList state;
  final NoteCallback onDecrease;
  final NoteCallback onIncrease;
  final NoteCallback deleteItem;
  const ItemListView({Key? key, required this.state , required this.onDecrease, required this.onIncrease, required this.deleteItem,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.currentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
                  child: Text(
                    state.currentList[index].name,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
              SizedBox(width: AppLayout.getWidth(8),),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        onDecrease(state.currentList[index]);
                      },
                      child: const Icon(Icons.remove),
                    ),
                    SizedBox(width: AppLayout.getWidth(4),),
                    Text(
                      state.currentList[index].quantity.toString(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: AppLayout.getWidth(4)),
                    InkWell(
                      onTap: () async {
                        onIncrease(state.currentList[index]);
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppLayout.getWidth(6),),
              InkWell(
                onTap: () async {
                  deleteItem(state.currentList[index]);
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );

  }
}
