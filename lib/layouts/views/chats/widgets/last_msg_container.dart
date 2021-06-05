import 'package:flutter/material.dart';
import 'package:dmman/models/message.dart';
import 'package:dmman/constants/msgs_to_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmman/utils/universal_variables.dart';

class LastMsgContainer extends StatelessWidget {
  final stream;

  LastMsgContainer({@required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message msg = Message.fromMap(docList.last.data);

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                msg.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Lato",
                  color: UniversalVariables.grey,
                  fontSize: 14,
                ),
              ),
            );
          }

          return Text(
            NO_MSG,
            style: TextStyle(
              fontFamily: "Sen",
              color: UniversalVariables.grey,
              fontSize: 14,
            ),
          );
        }

        return Text(
          "..",
          style: TextStyle(
            fontFamily: "Inter",
            color: UniversalVariables.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
}
