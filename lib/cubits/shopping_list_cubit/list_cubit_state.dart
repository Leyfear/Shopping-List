import 'package:equatable/equatable.dart';
import 'package:shopping_list_task/utils/custom_equatable.dart';

import '../../service/shopping_item.dart';

abstract class CubitListStates extends CustomEquatable{
}

class InitialState extends CubitListStates{
  @override
  List<Object?> get props => [];

}

class EditCurrentList extends CubitListStates{
  EditCurrentList( this.currentList);
  final List<ShoppingItem> currentList;

  @override
  List<Object?> get props => [currentList];
}

class EmptyListState extends CubitListStates{
  EmptyListState( this.shouldShowSnackBar);
  final bool shouldShowSnackBar;
  @override
  List<Object?> get props => [];
}


