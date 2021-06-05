import 'package:dmman/models/log.dart';

abstract class LogInterface {
  openDB(dbName);

  init();

  addLogs(Log log);

  /// returns a list of logs
  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}
