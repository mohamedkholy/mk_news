import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart ';
import 'package:mknews/ApiResponse.dart';

class MyDatabase {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      return await initDb();
    } else {
      return _db!;
    }
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "news.db");
    bool exist = await databaseExists(path);
    if (exist) {
      return await openDatabase(path);
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "news.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      return await openDatabase(path);
    }
  }

  saveOfflineArticles(List<Article> articles, String tableName) async {
    Database myDb = await db;

    articles.forEach((element) async {
      await myDb.rawQuery(
          "insert into $tableName values ('${element.source?.id.toString()}' , '${element.author.toString()}' , '${element.title.toString()}' , '${element.description.toString()}' , '${element.url.toString()}' , '${element.urlToImage.toString()}' , '${element.publishedAt.toString()}' , '${element.content.toString()}' , '${element.source?.name.toString()}')");
    });
  }

  // Future<List<Article>>
  Future<List<Article>> getOfflineArticles(String tableName) async {
    List<Article> list = [];
    Database myDb = await db;
    List<Map<String, Object?>> response =
        await myDb.rawQuery("select * from $tableName");
    response.forEach((element) {
      list.add(Article(
          source: Source(
              id: element["id"].toString(), name: element["name"].toString()),
      author: element["author"].toString(),content: element["content"].toString(),description: element["description"].toString(),publishedAt:element["publishedAt"].toString(),title: element["title"].toString(),url: element["url"].toString(),urlToImage: element["urlToImage"].toString() ));
    });
    return list;
  }


  deleteSavedArticles()async{
    Database myDb = await db;
    await myDb.rawQuery("delete from BusinessArticles;delete from SportsArticles;delete from HeadlineArticles");
  }

}
