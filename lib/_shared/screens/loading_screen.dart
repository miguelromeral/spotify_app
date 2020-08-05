import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

/// Loading screen to show while main content being loaded
class LoadingScreen extends StatelessWidget {
  /// Title of the screen
  final String title;
  /// Secondary text of the screen
  final List<String> stringBelow;
  /// Indicates if the content should be wrapped in a safe area
  final bool safeArea;

  LoadingScreen({
    Key key,
    this.title,
    this.stringBelow,
    this.safeArea,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (safeArea != null && safeArea) {
      // Wrap in a safe are if needed
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildContent(context),
        ),
      );
    } else {
      return _buildContent(context);
    }
  }

  /// Build the main content of the loading screen
  Widget _buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadingText(
            mainTitle,
            style: _styleLoading,
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(children: _getContentBelow()),
        ],
      ),
    );
  }

  /// Main title of the screen. If not provided, set the default
  String get mainTitle => title ?? 'Loading...';

  /// Set descriptive details of the loading screen.
  List<Widget> _getContentBelow() {
    if (stringBelow == null) {
      return [
        Text(
          "Please, wait a moment.",
        ),
      ];
    } else {
      return stringBelow.map((e) => Text(e)).toList();
    }
  }

  final TextStyle _styleLoading = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
}

