import 'package:flutter/material.dart';
import 'package:ShareTheMusic/services/gui.dart';

/// Widget that shows text info
class CardInfo extends StatelessWidget {
  /// Title of the data
  final String title;
  /// Content of the data
  final String content;

  CardInfo({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: styleCardHeader,
          ),
          Text(
            content,
            style: styleCardContent,
          ),
        ],
      ),
    );
  }
}
