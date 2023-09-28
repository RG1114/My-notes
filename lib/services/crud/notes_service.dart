import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' ;
import 'package:path/path.dart' show join;


class DatabaseAlreadyOpenException implements Exception{}
class UnableToGetDocumentsDirectory implements Exception{}
class DatabaseIsNotOpen implements Exception{}
class CouldNotDeleteUser implements Exception{}
class UserAlreadyExists implements Exception{}
class CouldNotFindUser implements Exception{}
class CouldNotDeleteNote implements Exception{}

class NotesService {

  Database? _db;
  Future<int>deleteAllNotes() async{
    final db=_getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async{
    final db=_getDatabaseOrThrow();
    final deletedCount=await db.delete(
      noteTable,
    where:'id = ?',
    whereArgs: [id],
    );
    if(deletedCount==0)
    {
      throw CouldNotDeleteNote();
    }
    

  }
  Future<DatabaseNote> createNote({required DatabaseUser owner})async
  {
    final db=_getDatabaseOrThrow();

    //make sure owner exists in the database with correct id 
    final dbUser=await getUser(email: owner.email);
    if(dbUser!=owner)
    {
      throw CouldNotFindUser();
    }

    const text='';
    //create note
    final noteId= await db.insert(noteTable,{
      userIdColumn:owner.id,
      textColumn:text,
      isSyncColumn:1
    });
    final note=DatabaseNote(
      id:noteId,
      userID: owner.id,
      text: text,
      isSync: true
      );
      return note;
  }
  Future<DatabaseUser> getUser({required String email})async{
    final db=_getDatabaseOrThrow();
    final results= await db.query(
      userTable,
      limit:1,
    where:'email = ?',
    whereArgs:[email.toLowerCase()],
    );
    if(results.isEmpty)
    {
      throw CouldNotFindUser();
    }else{
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email})async{
    final db=_getDatabaseOrThrow();
    final results= await db.query(
      userTable,
      limit:1,
    where:'email = ?',
    whereArgs:[email.toLowerCase()],
    );
    if(results.isNotEmpty)
    {
      throw UserAlreadyExists();
    }
    final userID =await db.insert(userTable,{
      emailColumn:email.toLowerCase(),
    } 
    );

    return DatabaseUser(
      id:userID,
      email:email,
    );
    }
  Future<void> deleteUser({required String email}) async{
    final db=_getDatabaseOrThrow();
    final deletedCount=await db.delete(
      userTable,
    where:'email = ?',
    whereArgs: [email.toLowerCase()],
    );
    if(deletedCount!=1)
    {
      throw CouldNotDeleteUser();
    }
    

  }
  Database _getDatabaseOrThrow()
  {
    final db=_db;
    if(db==null)
    {
      throw DatabaseIsNotOpen();
    }
    else{
      return db;
    }
  }
  Future<void> close() async{
    final db=_db;
    if(db==null)
    {
      throw DatabaseIsNotOpen();
    }else{
      await db.close();
      _db=null;

    }

  }
  Future<void>open()async{
    if(_db!=null)
    {
      throw DatabaseAlreadyOpenException();
    }
    try{
      final docsPath=await getApplicationDocumentsDirectory();
      final dbPath=join(docsPath.path,dbName);
      final db =await openDatabase(dbPath);
      _db=db;

      
      await db.execute(createUserTable);
      
  await db.execute(createNoteTable);


    }on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectory();
    }
  }
}


@immutable
class DatabaseUser{
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String,Object?>map): id=map[idColumn] as int ,email=map[emailColumn] as String;
  @override
  String toString()=>'Person, ID=$id,email=$email';

  @override
  bool operator ==(covariant DatabaseUser other)=>id==other.id;
  
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
  
}

class DatabaseNote{
  final int id;
  final int userID;
  final String text;
  final bool isSync;

  DatabaseNote({
  required this.id, 
  required this.userID, 
  required this.text, 
  required this.isSync
  });
  DatabaseNote.fromRow(Map<String,Object?>map): 
  id=map[idColumn] as int ,
  userID=map[userIdColumn] as int,
  text=map[textColumn] as String,
  isSync=
  (map[isSyncColumn] as int )==1?true:false;

  @override
  String toString()=>'Note ,ID=$id , userId=$userID, IsSync = $isSync';

   @override
  bool operator ==(covariant DatabaseNote other)=>id==other.id;
  
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
  


  
}

const dbName='notes.db';
const noteTable='note';
const userTable='user';
const idColumn='ID';
const emailColumn='email';
const userIdColumn='user_id';
const textColumn='text';
const isSyncColumn='is_synced';
const createUserTable=''' 
          CREATE TABLE IF NOT EXISTS "user" (
      "ID"	INTEGER NOT NULL,
      "email"	TEXT NOT NULL UNIQUE,
      PRIMARY KEY("ID" AUTOINCREMENT)
    );
''';
const createNoteTable='''
      CREATE TABLE IF NOT EXISTS "note" (
        "ID"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("ID"),
        PRIMARY KEY("ID" AUTOINCREMENT)
      );
''';