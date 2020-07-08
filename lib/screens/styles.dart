import 'package:flutter/material.dart';

const kShrinePink50 = const Color(0xFFFEEAE6);
const kShrinePink100 = const Color(0xFFFEDBD0);
const kShrinePink300 = const Color(0xFFFBB8AC);
const kShrinePink400 = const Color(0xFFEAA4A4);
const kShrineBrown900 = const Color(0xFF442B2D);
const kShrineErrorRed = const Color(0xFFC5032B);
const kShrineSurfaceWhite = const Color(0xFFFFFBFA);
const kShrineBackgroundWhite = Colors.white;

Color colorAccent = Colors.green[500];

final ThemeData kShrineTheme = _buildShrineTheme();

//const backgroundColor = const Colors;

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  //return base;
  return base.copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.green[900],
    accentColor: colorAccent,
    scaffoldBackgroundColor: Colors.black,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: Colors.pink,
      colorScheme: base.colorScheme.copyWith(
        secondary: Colors.yellow,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      backgroundColor: Colors.red,
      elevation: 300,
    ),

    /*
    
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,*/
  );
}
