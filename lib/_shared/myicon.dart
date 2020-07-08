import 'package:flutter/material.dart';
import 'package:spotify_app/screens/styles.dart';

class MyIcon extends StatelessWidget {
  String icon;
  double size;
  Function callback;
  final String _path = 'assets/icons/';
  final String _suffix = '.png';

  String get iconPath => '$_path$icon$_suffix';

  MyIcon({@required this.size, @required this.icon, this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: callback,
        child: Container(
            width: size,
            height: size,
            child: Image(color: colorIcon, image: AssetImage(iconPath))));
  }
}
