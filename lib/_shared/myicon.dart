import 'package:flutter/material.dart';
import 'package:spotify_app/screens/styles.dart';

class MyIcon extends StatefulWidget {
  String icon;
  double size;
  Function callback;
  MyIcon({this.size, @required this.icon, this.callback});

  @override
  _MyIconState createState() => _MyIconState();
}

class _MyIconState extends State<MyIcon> {
  bool _visible = true;
  final String _path = 'assets/icons/';
  final String _suffix = '.png';
  String get iconPath => '$_path${widget.icon}$_suffix';

  int duration = 500;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: execute,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: duration),
        // The green box must be a child of the AnimatedOpacity widget.
        child: Container(
            width: widget.size,
            height: widget.size,
            child: Image(color: colorIcon, image: AssetImage(iconPath))),
      ),
    );
  }

  Future execute() async {
    if (widget.callback != null) {
      setState(() {
        _visible = false;
      });
      widget.callback.call();
      await Future.delayed(Duration(milliseconds: duration));
      setState(() {
        _visible = true;
      });
    }
  }

}
