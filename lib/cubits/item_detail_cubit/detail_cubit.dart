import 'package:bloc/bloc.dart';
import 'package:shopping_list_task/service/shopping_item.dart';

import '../../service/crud/shopping_service.dart';
import 'detail_cubit_state.dart';

class DetailCubit extends Cubit<CubitDetailState>{
  final ItemService _itemService;

  List<ShoppingItem> currentList = [];
  DetailCubit( this._itemService) : super(InitialState());


  Future<void> getDetailItems(ShoppingList list) async{
    currentList = await _itemService.getItemsFromId(list.id);
    emit(CurrentDetailListState(currentList, list.createdAt));
  }

}