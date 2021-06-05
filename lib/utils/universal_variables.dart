import 'package:flutter/material.dart';

class UniversalVariables {
  static final Color black = Color(0xff19191b);
  static final Color blue = Color(0xff2b9ed4);
  static final Color grey = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlue = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);
  static final Color pc = Color(0xFF2BDACF); // primary color

  static final Color gradientColorStart = Color(0xff00b6f3);
  static final Color gradientColorEnd = Color(0xff0184dc);

  static final Color senColor = Color(0xff2b343b);
  static final Color recColor = Color(0xff1e2225);

  static final Gradient fabGradient = LinearGradient(
      colors: [pc, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
