import 'package:flutter/material.dart';
import 'package:ShareTheMusic/screens/styles.dart';

class CustomCard extends StatefulWidget {
  final List<Widget> content;

  CustomCard({this.content});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: colorThirdBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        width: constraints.maxWidth - 30.0,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.content,
          ),
        ),
      );
    });
  }
}
