import 'package:flutter/material.dart';
import 'package:dmman/models/user.dart';
import 'package:dmman/utils/utils.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:dmman/contents/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.OFFLINE:
          return Colors.red;

        case UserState.ONLINE:
          return Colors.green;

        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          User user;

          if (snapshot.hasData && snapshot.data.data != null) {
            user = User.fromMap(snapshot.data.data);
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          );
        },
      ),
    );
  }
}
