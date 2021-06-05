import 'package:flutter/material.dart';
import 'package:dmman/models/call.dart';
import 'package:provider/provider.dart';
import 'package:dmman/utils/progress.dart';
import 'package:dmman/api/call_methods.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmman/layouts/call/pickup/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({@required this.scaffold});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);

                if (!call.hasDialled) {
                  return PickupScreen(
                    call: call,
                  );
                }

                return scaffold;
              }

              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: circularProgress(),
            ),
          );
  }
}
