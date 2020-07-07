import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  String icon;
  double size;
  Function callback;
  final String _path = 'assets/icons/';

  String get iconPath => '$_path$icon';

  MyIcon({@required this.size, @required this.icon, this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: callback,
        child: Container(
            width: size,
            height: size,
            child: Image(image: AssetImage(iconPath))));
  }
}
