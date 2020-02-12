import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:http/http.dart'as http;
import 'package:sqflite/sqflite.dart';

class SqliteHelper{
  final sqlFileName = 'mydb.sql';
  final table = 'user';
  Database db;
  open()async{
    String path = "${await getDatabasesPath()}/$sqlFileName";

    if(db == null){
      db = await openDatabase(path,version: 1,onCreate: (db,ver)async{
        await db.execute('''
        Create Table user(
        userId integer primary key,
        nikeName text,
        gender text,
        identity text,
        location text,
        birth text
        );
        ''');
      });
    }
  }
  insert(Map<String, dynamic> m)async{
    await db.insert(table, m);
  }
  queryAll()async{
    return await db.query(table,columns: null);
  }
  delete(int id)async{
    return await db.delete(table,where: 'userId=$id');
  }
  close() async {
    return db.close();
  }
}