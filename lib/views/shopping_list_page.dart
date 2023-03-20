import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_task/const/routes.dart';
import 'package:shopping_list_task/cubits/shopping_list_cubit/list_cubit.dart';
import 'package:shopping_list_task/service/shopping_item.dart';
import 'package:shopping_list_task/views/item_list_view.dart';
import '../cubits/shopping_list_cubit/list_cubit_state.dart';
import '../service/crud/shopping_service.dart';
import '../utils/app_layout.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _controller = TextEditingController();
  final _service = ItemService();
  @override
  void initState() {
    _service.open();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    _service.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopping List"),
          actions: [
            IconButton(
                onPressed: () {
                  _controller.clear();
                  Navigator.pushNamed(context, historyPage);
                },
                icon: const Icon(Icons.history)),
            BlocBuilder<ListCubit, CubitListStates>(
              builder: (context, state) {
                return Visibility(
                  visible: state is! EmptyListState,
                  child: IconButton(
                    onPressed: () {
                      context.read<ListCubit>().deleteList();
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(15)),
            child: Column(
              children: [
                BlocConsumer<ListCubit, CubitListStates>(
                  listener: (context, state) {
                    if (state is EmptyListState && state.shouldShowSnackBar) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Succsses!'),
                            content:
                                const Text("The list created successfully"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is EditCurrentList) {
                      return SizedBox(
                          height: AppLayout.getScreenHeight() * 0.3,
                          width: AppLayout.getScreenWidth(),
                          child: ItemListView(
                            state: state,
                            onDecrease: (ShoppingItem item) {
                              context.read<ListCubit>().decreaseItemCount(item);
                            },
                            onIncrease: (ShoppingItem item) {
                              context.read<ListCubit>().increaseItemCount(item);
                            },
                            deleteItem: (ShoppingItem item) {
                              context.read<ListCubit>().deletePerItem(item);
                            },
                          ));
                    } else if (state is InitialState) {
                      context.read<ListCubit>().getCurrentListId();
                      return const CircularProgressIndicator();
                    } else if (state is EmptyListState) {
                      return SizedBox(
                        height: AppLayout.getScreenHeight() * 0.3,
                        width: AppLayout.getScreenWidth(),
                        child: const Center(
                            child: Text("There is nothing on the list.")),
                      );
                    } else {
                      return SizedBox(
                        height: AppLayout.getScreenHeight() * 0.3,
                        width: AppLayout.getScreenWidth(),
                        child: const Center(
                            child: Text("There is nothing on the list.")),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: AppLayout.getHeight(30),
                ),
                InkWell(
                  onTap: () {
                    context.read<ListCubit>().complateList();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: AppLayout.getWidth(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppLayout.getHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: TextField(
                          autofocus: false,
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter an item',
                            contentPadding: EdgeInsets.all(8.0),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppLayout.getScreenHeight() * 0.06,
                      width: AppLayout.getScreenWidth() * 0.2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            final shoppingItem = ShoppingItem(
                              id: 0,
                              name: _controller.text.trim(),
                              quantity: 1,
                            );
                            context.read<ListCubit>().addOrUpdateItem(shoppingItem);
                            _controller.clear();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
