import 'package:dmman/constants/msgs_to_user.dart';
import 'package:flutter/material.dart';
import 'package:dmman/layouts/search_screen.dart';
import 'package:dmman/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  fontFamily: "Sen"
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.pc,
                child: Text(
                  START_SEARCH,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Inter",
                    // letterSpacing: 1.2,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
