import 'package:flutter/material.dart';
import 'package:shopping_list_task/cubits/history_list_cubit/history_cubit.dart';
import 'package:shopping_list_task/cubits/item_detail_cubit/detail_cubit.dart';
import 'package:shopping_list_task/service/crud/shopping_service.dart';
import 'package:shopping_list_task/views/history_page.dart';
import 'package:shopping_list_task/views/item_detail_page.dart';
import 'package:shopping_list_task/views/shopping_list_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'const/routes.dart';
import 'cubits/shopping_list_cubit/list_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListCubit>(
            create: (context) => ListCubit(ItemService()),
          ),
        ],
        child: const ShoppingListPage(),
      ),
      routes: {
        historyPage: (_) => BlocProvider<HistroyCubit>(
          create: (context) => HistroyCubit(ItemService()),
          child: const HistoryPage(),
        ),
        detailPage: (_) => BlocProvider<DetailCubit>(
          create: (context) => DetailCubit(ItemService()),
          child: const ItemDetailPage(),
        ),
      },
    );
  }
}
