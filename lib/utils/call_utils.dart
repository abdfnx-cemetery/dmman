import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dmman/models/log.dart';
import 'package:dmman/models/call.dart';
import 'package:dmman/models/user.dart';
import 'package:dmman/api/call_methods.dart';
import 'package:dmman/constants/strings.dart';
import 'package:dmman/layouts/call/call_screen.dart';
import 'package:dmman/api/local_db/repo/log_repo.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      recId: to.uid,
      recName: to.name,
      recPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      recName: to.name,
      recPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      LogRepo.addLogs(log);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
