import 'package:meta/meta.dart';
import 'package:dmman/models/log.dart';
import 'package:dmman/api/local_db/db/hive_methods.dart';
import 'package:dmman/api/local_db/db/sqlite_methods.dart';

class LogRepo {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive, @required String dbName}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.openDB(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
