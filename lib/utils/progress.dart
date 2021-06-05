import 'package:flutter/material.dart';
import 'package:dmman/utils/universal_variables.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(UniversalVariables.pc),
    ),
  );
}