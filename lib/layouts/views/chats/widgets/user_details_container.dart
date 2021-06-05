import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmman/models/user.dart';
import 'package:dmman/widgets/appBar.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:dmman/widgets/cached_image.dart';
import 'package:dmman/layouts/login_screen.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:dmman/layouts/views/chats/widgets/logo.dart';

class UserDetailsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();

      if (isLoggedOut) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: Logo(),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => signOut(),
                  child: Text("Sign out",
                      style: TextStyle(
                          fontFamily: "Sen",
                          color: Colors.white,
                          fontSize: 12))),
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Razed",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: "Sen",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
