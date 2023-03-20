import 'package:shopping_list_task/service/shopping_item.dart';
import 'package:shopping_list_task/utils/custom_equatable.dart';

abstract class CubitHistoryState extends CustomEquatable{

}

class InitialState extends CubitHistoryState{
  @override
  List<Object?> get props => [];
}

class LoadingState extends CubitHistoryState{
  @override
  List<Object?> get props => [];
}

class EmptyListState extends CubitHistoryState{
  @override
  List<Object?> get props => [];
}


class EditingHistoryListState extends CubitHistoryState{
  EditingHistoryListState( this.currentList);
  final List<ShoppingList> currentList;

  @override
  List<Object?> get props => [currentList];
}





