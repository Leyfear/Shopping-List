import '../../service/shopping_item.dart';
import '../../utils/custom_equatable.dart';

abstract class CubitDetailState extends CustomEquatable{}


class InitialState extends CubitDetailState{
  @override
  List<Object?> get props => [];
}


class CurrentDetailListState extends CubitDetailState{
  CurrentDetailListState( this.currentList, this.complateDate);
  final List<ShoppingItem> currentList;
  final String complateDate;

  @override
  List<Object?> get props => [currentList,complateDate];
}


