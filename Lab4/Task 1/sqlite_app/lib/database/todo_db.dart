import 'package:sqflite/sqflite.dart';
import 'package:sqlite_app/database/db_service.dart';
import 'package:sqlite_app/model/todo.dart';

class TodoDB {
  final tableName = 'todos';

  //#region Insert

  Future<int> insert({required String title}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert('''
      INSERT INTO $tableName (title, created_at) VALUES (?,?) 
      ''', [title, DateTime.now().millisecondsSinceEpoch]);
  }

  //#endregion

  //#region Create

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTERGER NOT NULL,
        "title" TEXT NOT NULL,
        "created_at" INTEGER NOT NULL DEFAULT(cast(strftime('%s', 'now') as integer)),
        "updated_at" INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    """);
  }

  //#endregion

  //#region Fetch

  // Fetch Using All
  Future<List<Todo>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery('''
        SELECT * FROM $tableName ORDER BY COALESCE(updated_at, created_at);''');
    return todos.map((todo) => Todo.fromSqfliteDatabase(todo)).toList();
  }

  // Fetch Using Id
  Future<Todo> FetchbyId(int id) async {
    final Database = await DatabaseService().database;
    final todo = await Database.rawQuery(
        '''SELECT * FROM $tableName WHERE id = ?''', [id]);
    return Todo.fromSqfliteDatabase((todo.first));
  }

  //#endregion

  //#region Update
  Future<int> update({required int id, String? title}) async {
    final db = await DatabaseService().database;
    return await db.update(
      tableName,
      {
        if (title != null) 'title': title,
        'updated_at': DateTime.now().microsecondsSinceEpoch,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }
  //#endregion

  //#region Delete
  Future<void> delete(int id) async {
    final db = await DatabaseService().database;
    await db.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }

  //#endregion
}
