import 'package:flutter/material.dart';
import 'package:dmman/models/log.dart';
import 'package:dmman/models/call.dart';
import 'package:dmman/api/call_methods.dart';
import 'package:dmman/constants/strings.dart';
import 'package:dmman/utils/permissions.dart';
import 'package:dmman/widgets/cached_image.dart';
import 'package:dmman/layouts/call/call_screen.dart';
import 'package:dmman/api/local_db/repo/log_repo.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({@required this.call});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      recName: widget.call.recName,
      recPic: widget.call.recPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepo.addLogs(log);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming ...",
              style: TextStyle(fontFamily: "Inter", fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(call: widget.call),
                              ))
                          : () {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
