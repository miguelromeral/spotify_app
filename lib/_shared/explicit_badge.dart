import 'package:ShareTheMusic/services/styles.dart';
import 'package:flutter/material.dart';

/// Shows a explicit badge in the track info
class ExplicitBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorThirdBackground,
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Text(
            'EXPLICIT',
            style: TextStyle(
              fontSize: 10.0,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          )),
    );
  }
}
