class Log {
  int logId;
  String callerName;
  String callerPic;
  String recName;
  String recPic;
  String callStatus;
  String timestamp;

  Log({
    this.logId,
    this.callerName,
    this.callerPic,
    this.recName,
    this.recPic,
    this.callStatus,
    this.timestamp,
  });

  // to map
  Map<String, dynamic> toMap(Log log) {
    Map<String, dynamic> logMap = Map();
    logMap["log_id"] = log.logId;
    logMap["caller_name"] = log.callerName;
    logMap["caller_pic"] = log.callerPic;
    logMap["rec_name"] = log.recName;
    logMap["rec_pic"] = log.recPic;
    logMap["call_status"] = log.callStatus;
    logMap["timestamp"] = log.timestamp;
    return logMap;
  }

  Log.fromMap(Map logMap) {
    this.logId = logMap["log_id"];
    this.callerName = logMap["caller_name"];
    this.callerPic = logMap["caller_pic"];
    this.recName = logMap["rec_name"];
    this.recPic = logMap["rec_pic"];
    this.callStatus = logMap["call_status"];
    this.timestamp = logMap["timestamp"];
  }
}
