import 'package:bloc/bloc.dart';
import 'package:path/path.dart';

import '../../service/crud/shopping_service.dart';
import '../../service/shopping_item.dart';
import 'history_cubit_state.dart';

class HistroyCubit extends Cubit<CubitHistoryState> {
  final ItemService _itemService;
  List<ShoppingList> currentList = [];

  HistroyCubit(this._itemService) : super(InitialState());

  Future<void> getHistoryLists() async {
    final list = await _itemService.getHistoryLists();
    currentList = list.toList(growable: true);
    if (currentList.isEmpty) {
      emit(EmptyListState());
    } else {
      emit(EditingHistoryListState(currentList));
    }
  }

  Future<void> deleteHistory(ShoppingList list) async {
    await _itemService.deleteHistory(list.id);
    currentList.removeWhere((historyList) => historyList.id == list.id);
    if (currentList.isEmpty) {
      emit(EmptyListState());
    } else {
      emit(EditingHistoryListState(currentList));
    }
  }
}
