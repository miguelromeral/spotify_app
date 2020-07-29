
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';

class TrackDuration extends StatelessWidget {
  
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
