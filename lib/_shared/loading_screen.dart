import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingScreen extends StatelessWidget {
  final String title;
  final List<Widget> below;

  LoadingScreen({
    Key key,
    this.title,
    this.below,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadingText(
            'Loading...',
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
      return [
        Text("Please, wait a moment."),
      ];
    } else {
      return below;
    }
  }

  final TextStyle _styleLoading = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
}
