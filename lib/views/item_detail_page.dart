import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_task/cubits/item_detail_cubit/detail_cubit.dart';
import 'package:shopping_list_task/cubits/item_detail_cubit/detail_cubit_state.dart';
import 'package:shopping_list_task/service/shopping_item.dart';
import 'package:shopping_list_task/utils/app_layout.dart';
import 'package:shopping_list_task/utils/generics/get_arguments.dart';

import '../service/crud/shopping_service.dart';
import 'detail_list_view.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({Key? key}) : super(key: key);

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
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
        title: BlocBuilder<DetailCubit, CubitDetailState>(
            builder: (context, state) {
          if (state is CurrentDetailListState) {
            return Text(state.complateDate);
          } else {
            return const Text("Unknown");
          }
        }),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left_sharp)),
      ),
      body: BlocBuilder<DetailCubit, CubitDetailState>(
        builder: (context, state) {
          if (state is InitialState) {
            final currentItem = context.getArgument<ShoppingList>();
            if (currentItem != null) {
              context.read<DetailCubit>().getDetailItems(currentItem);
            }
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrentDetailListState) {
            return Container(
                padding: EdgeInsets.only(
                    top: AppLayout.getHeight(10),
                    left: AppLayout.getWidth(10),
                    right: AppLayout.getWidth(10)),
                child: DetailList(
                  state: state,
                ));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
