import 'package:flutter/material.dart';
import 'package:dmman/models/log.dart';
import 'package:dmman/utils/utils.dart';
import 'package:dmman/widgets/tile.dart';
import 'package:dmman/utils/progress.dart';
import 'package:dmman/constants/strings.dart';
import 'package:dmman/widgets/cached_image.dart';
import 'package:dmman/constants/msgs_to_user.dart';
import 'package:dmman/api/local_db/repo/log_repo.dart';
import 'package:dmman/layouts/views/logs/widgets/quiet_box.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepo.getLogs(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: circularProgress());
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i];
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

                return CustomTile(
                  leading: CachedImage(
                    hasDialled ? _log.recPic : _log.callerPic,
                    isRound: true,
                    radius: 45,
                  ),
                  mini: false,
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(DELETE_THIS_LOG, style: TextStyle(
                        fontFamily: "Sen",
                      ),),
                      content:
                          Text(ARE_YOU_SURE, style: TextStyle(
                            fontFamily: "OS"
                          ),),
                      actions: [
                        FlatButton(
                          child: Text("YES", style: TextStyle(
                            fontFamily: "Razed",
                          )),
                          onPressed: () async {
                            Navigator.maybePop(context);
                            await LogRepo.deleteLogs(i);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("NO", style: TextStyle(fontFamily: "Razed"),),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    hasDialled ? _log.recName : _log.callerName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  icon: getIcon(_log.callStatus),
                  subtitle: Text(
                    Utils.formatDateString(_log.timestamp),
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                );
              },
            );
          }
          return QuietBox(
            heading: THIS_IS_ALL,
            subtitle: CALLING_PEOPLE,
          );
        }

        return QuietBox(
          heading: THIS_IS_ALL,
          subtitle: CALLING_PEOPLE,
        );
      },
    );
  }
}
