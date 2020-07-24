import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingScreen extends StatelessWidget {
  final String title;
  final List<Widget> below;
  final List<String> stringBelow;
  final bool safeArea;

  LoadingScreen({
    Key key,
    this.title,
    this.stringBelow,
    this.below,
    this.safeArea,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (safeArea != null && safeArea) {
      return Scaffold(
        body: SafeArea(
          child: FancyBackgroundApp(
            content: _buildContent(context),
          ),
          //child: _buildContent(context),
        ),
      );
    } else {
      return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadingText(
            _getTitle(),
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

  String _getTitle() => title ?? 'Loading...';

  List<Widget> _getContentBelow() {
    if (below == null) {
      if (stringBelow == null) {
        return [
          Text(
            "Please, wait a moment.",
          ),
          //Text("Please, try again later."),
        ];
      } else {
        return stringBelow.map((e) => Text(e)).toList();
      }
    } else {
      return below;
    }
  }

  final TextStyle _styleLoading = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
}
