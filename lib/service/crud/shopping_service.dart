import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../crud_exceptions.dart';
import '../shopping_item.dart';

class ItemService {
  Database? _db;

  static final ItemService _shared = ItemService._sharedInstance();
  ItemService._sharedInstance();
  factory ItemService() => _shared;

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createItemTable);
      await db.execute(createItemListTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }


  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }


  Future<int> createOrGetListId() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final lastList = await getLastList();
    final now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy-HH:mm').format(now);


    if(lastList != null && !lastList.isCompleted){
      return lastList.id;
    }else{
      final newItem = db.insert(itemListTable, {
          isCompletedColumn : 0,
          createdAtColumn : formattedDate,

      },);
      return newItem;
    }
  }

  Future<List<ShoppingItem>> getItemsFromId(int id) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final items = await db.query(
        itemTable,
      where: 'listId = ?',
      whereArgs: [id],
    );
    final list = items.map((noteRow) => ShoppingItem.fromRow(noteRow));
    final as = list.toList(growable: true);
    return as;

  }

  Future<Iterable<ShoppingItem>> getAllItems() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final items = await db.query(itemTable);

    return items.map((noteRow) => ShoppingItem.fromRow(noteRow));
  }

  Future<Iterable<ShoppingList>> getAllItemsRev() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final items = await db.query(itemListTable);
    return items.map((noteRow) => ShoppingList.fromRow(noteRow));
  }

  Future<ShoppingList?> getLastList() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final lastItemList = await db.query(
      itemListTable,
      limit: 1,
      orderBy: 'id DESC',
    );
    if(lastItemList.isNotEmpty){
      final fromRow = ShoppingList.fromRow(lastItemList.first);
      return fromRow;
    }else{
      return null;
    }

  }

  Future<ShoppingItem> addOrUpdateItem(ShoppingItem item,int currentListId ) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final items = await getItem(item.name,currentListId);
    if (items != null) {
      final id = await db.update(itemTable,
        {
          quantityColumn: items.quantity + 1,
        },
        where: 'id = ?',
        whereArgs: [items.id],);
        return ShoppingItem(id: id, name: items.name, quantity: items.quantity + 1, userId: currentListId);
    }
    else {
      final listId = currentListId;
      final noteId = await db.insert(itemTable, {
        listIdColumn: listId,
        textColumn: item.name,
        quantityColumn : 1,
      });
      return ShoppingItem(id: noteId, name: item.name, quantity: 1, userId: currentListId);
    }
  }

  Future<void> deleteItem({required ShoppingItem item}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      itemTable,
      where: 'name = ?',
      whereArgs: [item.name],
    );
  }

  Future<int> deleteList(int id) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(itemTable,
      where: 'listId = ?',
      whereArgs: [id],);
    return numberOfDeletions;
  }

  Future<void> increaseItemCount(ShoppingItem item) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
     await db.update(itemTable,
        {
          quantityColumn: item.quantity + 1,
        },
        where: 'id = ?',
        whereArgs: [item.id],);
  }

  Future<void> decreaseItemCount(ShoppingItem item) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();


    await db.update(itemTable,
      {
        quantityColumn: item.quantity - 1,
      },
      where: 'name = ?',
      whereArgs: [item.name],);
  }

  Future<void> complateList(int userId) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy-HH:mm').format(now);

    await db.update(itemListTable,
      {
        isCompletedColumn: 1,
        createdAtColumn : formattedDate
      },
      where: 'id = ?',
      whereArgs: [userId],);

  }

  Future<Iterable<ShoppingList>> getHistoryLists() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final itemsList = await db.query(itemListTable);
    final allItem = itemsList.map((noteRow) => ShoppingList.fromRow(noteRow));
    return allItem.where((element) => element.isCompleted == true);
  }

  Future<void> deleteHistory(int id) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    db.delete(itemListTable,
      where: 'id = ?',
      whereArgs: [id],);
    db.delete(itemTable,
      where: 'listId = ?',
      whereArgs: [id],);
  }

  Future<ShoppingItem?> getItem( String name,  int listId) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final shoppingItem = await db.query(
      itemTable,
      limit: 1,
      where: 'name = ? AND listId = ?',
      whereArgs: [name,listId],
    );
    print("item");
    print(shoppingItem);
    if (shoppingItem.isEmpty) {
      return null;
    } else {
      final item = ShoppingItem.fromRow(shoppingItem.first);
      return item;
    }
  }
}

const createItemListTable = '''CREATE TABLE IF NOT EXISTS "itemList" (
         "id"	INTEGER NOT NULL,
          "isCompleted"	INTEGER NOT NULL DEFAULT 0,
	        "createdAt"	TEXT NOT NULL,
         PRIMARY KEY("id" AUTOINCREMENT)
       );''';

const createItemTable = '''CREATE TABLE IF NOT EXISTS "item" (
         	"id"	INTEGER,
	        "name"	TEXT,
	        "listId" INTEGER NOT NULL,
	        "quantity"	INTEGER,
	        FOREIGN KEY (listId) REFERENCES itemList(id),
	        PRIMARY KEY("id" AUTOINCREMENT)
       );''';

const dbName = 'notes.db';
const itemListTable = 'itemList';
const itemTable = 'item';

const idColumn = 'id';
const isCompletedColumn  = 'isCompleted';
const nameColumn = 'name';
const listIdColumn = 'listId';
const textColumn = 'name';
const quantityColumn = 'quantity';
const createdAtColumn = 'createdAt';



