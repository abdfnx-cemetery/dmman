import 'package:flutter/material.dart';
import 'package:dmman/utils/universal_variables.dart';

class FloatingColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: UniversalVariables.fabGradient,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25,
          ),
          padding: EdgeInsets.all(15),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UniversalVariables.black,
              border: Border.all(
                width: 2,
                color: UniversalVariables.pc,
              )),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.pc,
            size: 25,
          ),
          padding: EdgeInsets.all(15),
        )
      ],
    );
  }
}