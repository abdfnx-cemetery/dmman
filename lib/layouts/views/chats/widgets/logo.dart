import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 50,
      width: 50,
      child: SvgPicture.asset(
          "assets/images/icon.svg",
          color: Colors.white,
          height: size.height * 0.001,
        ),
    );
  }
}