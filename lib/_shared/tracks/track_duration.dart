import 'package:ShareTheMusic/services/styles.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';

/// Widget that prints the duration of a track given the duration in milliseconds
class TrackDuration extends StatelessWidget {
  /// Duration in milliseconds
  final int duration;

  TrackDuration({
    Key key,
    @required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.0),
        color: colorThirdBackground,
        child: Text(printDuration(duration, false)));
  }
}
