import 'dart:io';
import 'package:dmman/models/log.dart';
import 'package:dmman/api/local_db/interface/log_interface.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveMethods implements LogInterface {
  String hiveBox = "";

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async {
    var box = await Hive.openBox(hiveBox);

    var logMap = log.toMap(log);

    // box.put("custom_key", logMap);
    int idOfInput = await box.add(logMap);

    close();

    return idOfInput;
  }

  updateLogs(int i, Log newLog) async {
    var box = await Hive.openBox(hiveBox);

    var newLogMap = newLog.toMap(newLog);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  openDB(dbName) => (hiveBox = dbName);

  @override
  Future<List<Log>> getLogs() async {
    var box = await Hive.openBox(hiveBox);

    List<Log> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);

      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hiveBox);

    await box.deleteAt(logId);
    // await box.delete(logId);
  }

  @override
  close() => Hive.close();
}
