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
Color colorPrimary = Colors.green[900];
Color colorBackground = Colors.black;
Color colorSemiBackground = Colors.black38;
Color colorThirdBackground = Colors.grey[900];
Color colorIcon = Colors.white54;
Color colorSeprator = Colors.white70;

Color colorError = Colors.red.shade200;
Color colorErrorDetail = Colors.red.shade400;

/*
Color _hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}*/

final ThemeData appTheme = _buildAppTheme();

//const backgroundColor = const Colors;

BoxDecoration backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colorThirdBackground, Colors.black, colorPrimary]));

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.dark();
  //return base;
  return base.copyWith(
    brightness: Brightness.dark,
    primaryColor: colorPrimary,
    accentColor: colorAccent,
    backgroundColor: Colors.transparent,
    scaffoldBackgroundColor: colorBackground,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: colorAccent,
      colorScheme: base.colorScheme.copyWith(
        secondary: colorPrimary,
      ),
    ),
    cardColor: colorThirdBackground,
    /*cardTheme: base.cardTheme.copyWith(
      color: Colors.red,
      elevation: 0,      
    ),*/
    snackBarTheme: base.snackBarTheme.copyWith(
      backgroundColor: colorAccent,
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      backgroundColor: colorSemiBackground,
      elevation: 300,
    ),
  );
}
