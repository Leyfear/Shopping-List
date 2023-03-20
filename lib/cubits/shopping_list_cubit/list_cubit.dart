import 'package:bloc/bloc.dart';
import 'package:shopping_list_task/service/shopping_item.dart';

import '../../service/crud/shopping_service.dart';
import 'list_cubit_state.dart';

class ListCubit extends Cubit<CubitListStates> {
  final ItemService _itemService;

  ListCubit(this._itemService) : super(InitialState()) {}
  late final allItemList;
  int currentListId = 0;
  List<ShoppingItem> currentList = [];

/*//for debug
  Future<void> getItems() async{

    try{

       final allItems = await _itemService.getAllItems();
       print("allItems");
      print(allItems);
       print(allItems.length);


      final getlAllItems = await _itemService.getAllItemsRev();
       print("allItems2");
      print(getlAllItems);
       print(getlAllItems.length);




      //allItemList = await _itemService.getAllItemList();
      //emit(LoadedState(allItems,allItemList));
    }catch(e){
    }
  }*/

  Future<void> complateList() async {
    if (currentList.isNotEmpty) {
      await _itemService.complateList(currentListId);
      currentList = [];
      currentListId = await _itemService.createOrGetListId();
      emit(EmptyListState(true));
    } else {}
  }

  Future<void> getCurrentList() async {
    try {
      currentList = await _itemService.getItemsFromId(currentListId);
      if (currentList.isEmpty) {
        emit(EmptyListState(false));
      } else {
        emit(EditCurrentList(currentList));
      }
    } catch (e) {}
  }

  Future<void> getCurrentListId() async {
    currentListId = await _itemService.createOrGetListId();
    getCurrentList();
  }

  Future<void> addOrUpdateItem(ShoppingItem shoppingItem) async {
    try {
      final newItem =
          await _itemService.addOrUpdateItem(shoppingItem, currentListId);
      currentList.removeWhere((shoppingItem) => shoppingItem.name == newItem.name);
      currentList.add(newItem);
      //currentList.where((element) => element.userId == currentListId);
      emit(EditCurrentList(currentList));
    } catch (_) {}
  }

  Future<void> deleteList() async {
    await _itemService.deleteList(currentListId);
    currentListId = await _itemService.createOrGetListId();
    currentList = [];
    emit(EmptyListState(false));
  }

  Future<void> deletePerItem(ShoppingItem item) async {
    await _itemService.deleteItem(item: item);
    currentList.removeWhere((element) => element.name == item.name);
    if (currentList.isEmpty) {
      currentList = [];
      emit(EmptyListState(false));
    } else {
      emit(EditCurrentList(currentList));
    }
  }

  void increaseItemCount(ShoppingItem shoppingItem) async {
    await _itemService.increaseItemCount(shoppingItem);
    final deger = shoppingItem.quantity += 1;
    currentList.firstWhere((item) => shoppingItem.name == item.name).quantity =
        deger;
    emit(EditCurrentList(currentList));
  }

  void decreaseItemCount(ShoppingItem shoppingItem) async {
    await _itemService.decreaseItemCount(shoppingItem);
    final deger = shoppingItem.quantity -= 1;
    if (deger == 0) {
      if (currentList.length == 1) {
        currentList = [];
        await _itemService.deleteList(shoppingItem.userId);
        currentListId = await _itemService.createOrGetListId();
        emit(EmptyListState(false));
        return;
      }
      _itemService.deleteItem(item: shoppingItem);
      currentList.removeWhere((element) => element.name == shoppingItem.name);
      emit(EditCurrentList(currentList));
    } else {
      currentList
          .firstWhere((item) => shoppingItem.name == item.name)
          .quantity = deger;
      emit(EditCurrentList(currentList));
    }
  }
}
