import 'package:flutter/material.dart';

/// Card Error Color
Color colorErrorCard = Colors.red[500];
/// Main Color
Color colorAccent = Colors.green[500];
/// Secondary Color
Color colorPrimary = Colors.green[900];
/// Background color, just black
Color colorBackground = Colors.black;
/// A slightly more light background color
Color colorSemiBackground = Colors.black38;
/// A not so dark black
Color colorThirdBackground = Colors.grey[900];
/// Icons color
Color colorIcon = Colors.white;
/// Color of the title screen error
Color colorError = Colors.red.shade200;
/// Color of the error screen details
Color colorErrorDetail = Colors.red.shade400;

/// Gets the app theme
final ThemeData appTheme = _buildAppTheme();

/// Gradient for the background of the app (without fancy background)
BoxDecoration backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colorThirdBackground, Colors.black, colorPrimary]));

/// Builds the app theme
ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.dark();
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

/// Style of the title in the feed elements
TextStyle styleFeedTitle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

/// Style of the text with the time of an item
TextStyle styleFeedAgo = TextStyle(
  color: Colors.white38,
  fontStyle: FontStyle.italic,
  fontSize: 10.0,
  fontWeight: FontWeight.normal,
);

/// Style of the text in a track
TextStyle styleFeedTrack = TextStyle(
  color: Colors.green[600],
);

/// Style of the text for the artists
TextStyle styleFeedArtist = TextStyle(
  color: Colors.green[900],
);

/// Style of the content in the list item
TextStyle styleFeedContent = TextStyle(
  fontSize: 16.0,
);

/// Style of the title in a card
TextStyle styleCardHeader =
    TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);

/// Style of the content in a card
TextStyle styleCardContent =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
