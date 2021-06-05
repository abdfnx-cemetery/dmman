class Call {
  String callerId;
  String callerName;
  String callerPic;
  String recId;
  String recName;
  String recPic;
  String channelId;
  bool hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.recId,
    this.recName,
    this.recPic,
    this.channelId,
    this.hasDialled,
  });

  // to map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;
    callMap["rec_id"] = call.recId;
    callMap["rec_name"] = call.recName;
    callMap["rec_pic"] = call.recPic;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
    return callMap;
  }

  Call.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.callerName = callMap["caller_name"];
    this.callerPic = callMap["caller_pic"];
    this.recId = callMap["rec_id"];
    this.recName = callMap["rec_name"];
    this.recPic = callMap["rec_pic"];
    this.channelId = callMap["channel_id"];
    this.hasDialled = callMap["has_dialled"];
  }
}
