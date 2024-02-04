import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_app/database/todo_db.dart';

class DatabaseService {
  Database? _database;

  Future<void> create(Database database, int version) async =>
      await TodoDB().createTable(database);

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<Database> get database async {
    if (_database != null) {
      // return current database
      return _database!;
    }
    // initialize database if it does not exist
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }
}
