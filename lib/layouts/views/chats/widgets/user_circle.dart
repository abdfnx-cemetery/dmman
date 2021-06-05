import 'package:flutter/material.dart';
import 'package:dmman/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:dmman/utils/universal_variables.dart';
import 'package:dmman/layouts/views/chats/widgets/user_details_container.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: UniversalVariables.black,
          builder: (context) => UserDetailsContainer(),
          isScrollControlled: true),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: UniversalVariables.grey.withOpacity(0.2)),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(Utils.getInitials(userProvider.getUser.name),
                  style: TextStyle(
                    fontFamily: "Sen",
                    fontWeight: FontWeight.bold,
                    color: UniversalVariables.pc,
                    fontSize: 13,
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(color: Colors.white, width: 2),
                  color: UniversalVariables.onlineDotColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
