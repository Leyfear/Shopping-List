import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_task/cubits/history_list_cubit/history_cubit.dart';
import 'package:shopping_list_task/cubits/history_list_cubit/history_cubit_state.dart';
import 'package:shopping_list_task/utils/app_layout.dart';

import '../const/routes.dart';
import '../service/crud/shopping_service.dart';
import '../service/shopping_item.dart';
import 'history_list_view.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}


class _HistoryPageState extends State<HistoryPage> {
  final _service = ItemService();
  @override
  void initState() {
    _service.open();
    super.initState();
  }
  @override
  void dispose() {
    _service.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left_sharp)),
      ),
      body: BlocBuilder<HistroyCubit, CubitHistoryState>(
          builder: (context, state) {
        if (state is InitialState) {
          context.read<HistroyCubit>().getHistoryLists();
          return const Center(child: CircularProgressIndicator());
        } else if (state is EditingHistoryListState) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(6)),
              padding: EdgeInsets.only(top: AppLayout.getHeight(10)),
              child: HistoryListView(
                state: state,
                deleteItem: (ShoppingList item) {
                  context.read<HistroyCubit>().deleteHistory(item);
                },
                onTap: (ShoppingList item) {
                  Navigator.of(context).pushNamed(
                    detailPage,
                    arguments: item,
                  );
                },
              ));
        } else if (state is EmptyListState) {
          return const Center(
              child: Text("There is nothing on the list.",));
        } else {
          return Container();
        }
      }),
    );
  }
}
