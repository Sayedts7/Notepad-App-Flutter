import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'notes_model.dart';


class DBhelper{

  static Database? _db;

  Future<Database?> get db async{

    if(_db != null){
      return _db!;
    }

    _db = await initDatabase();
    return null;
  }
  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'Notes.db');
    var db = await openDatabase(path, version:1, onCreate: _onCreate );
    return db;
  }

  _onCreate(Database db, int version )async{
    await db
        .execute('CREATE TABLE Notes (id INTEGER PRIMARY KEY AUTOINCREMENT , time VARCHAR UNIQUE , title TEXT, description TEXT,  picture TEXT)');

  }

  Future<Note> insert(Note notes)async{
    print(notes.toMap());
    var dbClient = await db ;
    await dbClient!.insert('Notes', notes.toMap());
    return notes ;
  }

  Future<List<Note>> getNoteList()async{
    var dbClient = await db ;
    final List<Map<String , Object?>> queryResult =  await dbClient!.query('Notes');
    return queryResult.map((e) => Note.fromMap(e)).toList();

  }

  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient!.delete(
        'Notes',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}