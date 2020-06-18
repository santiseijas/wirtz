import 'package:flutter/material.dart';

class FintnessAppTheme {
  FintnessAppTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);




  static const Color darkerText = Color(0xFF17262A);

  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';





  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: darkerText, // was lightText
  );
}