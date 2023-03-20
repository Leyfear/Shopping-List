import 'package:shopping_list_task/service/crud/shopping_service.dart';

class ShoppingList{
  int id;
  //List<ShoppingItem> items ;
  String createdAt;
  bool isCompleted;

  ShoppingList({required this.id , required this.createdAt, required this.isCompleted});
  ShoppingList.fromRow(Map<String, Object?> map):
        id = map[idColumn] as int,
        isCompleted = (map[isCompletedColumn] as int) == 1 ? true : false,
     // items = map[itemColumn] as  List<ShoppingItem>,
        createdAt = map[createdAtColumn] as String;


}

class ShoppingItem {
  int id;
  String name;
  int quantity;
   int userId;

  ShoppingItem({required this.id, required this.name, required this.quantity, this.userId = 0});
  ShoppingItem.fromRow(Map<String, Object?> map):
      id = map[idColumn] as int,
      name = map[nameColumn] as String,
        userId = map[listIdColumn] as int,
        quantity = map[quantityColumn] as int;


}



const idColumn = 'id';
const nameColumn = 'name';
const quantityColumn = 'quantity';


const itemColumn = 'item';

const createdAtColumn = 'createdAt';