import 'dart:io';
import 'package:flutter_wish_list/Models/ItemArticle.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_wish_list/Models/Item.dart';

class DatabaseClient {
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await createDb();
      return _database;
    }
  }

  Future createDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String databaseDirectory = join(directory.path, 'database.db');
    var bdd =
        await openDatabase(databaseDirectory, version: 1, onCreate: _createDb);
    return bdd;
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item (
      id INTEGER PRIMARY KEY, 
      name TEXT NOT NULL)
    ''');
    await db.execute('''
    CREATE TABLE itemArticle (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      itemId INTEGER NOT NULL,
      price TEXT,
      magasin TEXT,
      image TEXT
    )
    ''');
  }

  /* DATA WRITE */

  Future<Item> addItem(Item item) async {
    Database myDb = await database;
    item.id = await myDb.insert('item', item.toMap());
    return item;
  }

  Future<int> removeItem(int id, String table) async {
    Database myDb = await database;
    await myDb.delete('itemArticle', where: 'itemId = ?', whereArgs: [id]);
    return myDb.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateItem(Item item) async {
    Database myDb = await database;
    return myDb
        .update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<Item> upsertItem(Item item) async {
    Database myDb = await database;
    if (item.id == null) {
      item.id = await myDb.insert('item', item.toMap());
    } else {
      await myDb
          .update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  Future<int> removeArticle(ItemArticle article) async {
    Database myDb = await database;
    return myDb.delete('itemArticle', where: 'id = ?', whereArgs: [article.id]);
  }

  Future<ItemArticle> upsertArticle(ItemArticle article) async {
    Database myDb = await database;
    if (article.id == null) {
      article.id = await myDb.insert('itemArticle', article.toMap());
    } else {
      await myDb.update('itemArticle', article.toMap(),
          where: 'id = ?', whereArgs: [article.id]);
    }
    return article;
  }

  /* DATA READ */

  Future<List<Item>> readAllItem() async {
    Database myDb = await database;
    List<Map<String, dynamic>> result =
        await myDb.rawQuery('SELECT * FROM item');
    List<Item> items = [];
    result.forEach((element) {
      Item item = Item();
      item.fromMap(element);
      items.add(item);
    });
    return items;
  }

  Future<List<ItemArticle>> readAllArticle(int itemId) async {
    Database myDb = await database;
    List<Map<String, dynamic>> result = await myDb
        .query('itemArticle', where: 'itemId = ?', whereArgs: [itemId]);
    List<ItemArticle> articles = [];
    result.forEach((element) {
      ItemArticle article = ItemArticle();
      article.fromMap(element);
      articles.add(article);
    });
    return articles;
  }
}
