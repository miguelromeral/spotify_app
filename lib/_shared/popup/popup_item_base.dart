import 'package:flutter/material.dart';

import '../myicon.dart';

abstract class PopupItemBase {
  String icon;
  String text;

  PopupItemBase({this.icon, this.text});

  void execute(BuildContext context);

  PopupMenuItem<PopupItemBase> create() {
    return PopupMenuItem(
      value: this,
      child: Row(
        children: <Widget>[
          MyIcon(
            icon: icon,
            size: 20.0,
          ),
          SizedBox(
            width: 6.0,
          ),
          Text(text),
        ],
      ),
    );
  }
}
