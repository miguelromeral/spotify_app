import 'package:flutter/material.dart';

import '../myicon.dart';

/// Base class to implement the popup menu options throughout the app
abstract class PopupItemBase {
  // Name of the asset of the icon to show
  String icon;
  // Text to show to the user
  String text;

  PopupItemBase({this.icon, @required this.text});

  // Every popup option has to execute some logic
  // Pass the context in case it's needed
  void execute(BuildContext context);

  PopupMenuItem<PopupItemBase> create() {
    return PopupMenuItem(
      value: this,
      child: Row(
        children: <Widget>[
          (icon != null
              ? MyIcon(
                  icon: icon,
                  size: 20.0,
                )
              : Container()),
          SizedBox(
            width: 6.0,
          ),
          Text(text),
        ],
      ),
    );
  }
}
