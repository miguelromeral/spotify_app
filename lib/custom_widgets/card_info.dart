import 'package:flutter/material.dart';

class CardInfo extends StatelessWidget {
  String title;
  String content;

  CardInfo({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic),
          ),
          Text(content),
        ],
      ),
    );
  }
}
