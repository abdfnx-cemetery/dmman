import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dmman/models/log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dmman/api/local_db/interface/log_interface.dart';

class SqliteMethods implements LogInterface {
  Database _db;

  String dbName = "";
  String tableName = "Call_Logs";

  // columns
  String id = 'log_id';
  String callerName = 'caller_name';
  String callerPic = 'caller_pic';
  String recName = 'rec_name';
  String recPic = 'rec_pic';
  String callStatus = 'call_status';
  String timestamp = 'timestamp';

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }

  @override
  openDB(dbName) => (dbName = dbName);

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$id = ?', whereArgs: [logId + 1]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;

    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          recName,
          recPic,
          callStatus,
          timestamp,
        ],
      );

      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (err) {
      print(err);
      return null;
    }
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, dbName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    return db;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    print("db was null, now awaiting it");
    _db = await init();
    return _db;
  }

  _onCreate(Database db, int v) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $recName TEXT, $recPic TEXT, $callStatus TEXT, $timestamp TEXT )";

    await db.execute(createTableQuery);
    print("table created");
  }
}
