import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dmman/utils/progress.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/fav.svg",
              height: size.height * 0.08,
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/images/signup.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.08),
            loginButton(),
          ],
        ),
      ),
      isLoginPressed
          ? Center(
              child: circularProgress(),
            )
          : Container()
    ]));
  }

  Widget loginButton() {
    return GestureDetector(
        onTap: preformLogin,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 270,
                height: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void preformLogin() {
    setState(() {
      isLoginPressed = true;
    });

    _authMethods.signIn().then((FirebaseUser user) {
      if (user != null) {
        authUser(user);
      } else {
        Fluttertoast.showToast(msg: "Try again, Sign in Failed...");
      }
    });
  }

  void authUser(FirebaseUser user) {
    _authMethods.authUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDB(user).then((val) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
