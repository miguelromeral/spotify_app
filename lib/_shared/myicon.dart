import 'package:flutter/material.dart';
import 'package:ShareTheMusic/services/styles.dart';

/// Icon that uses a custom asset in the app
class MyIcon extends StatefulWidget {
  /// Name of the asset icon. No path required nor extension
  final String icon;
  /// Size of the icon
  final double size;
  /// Fuction to be executed when tapped
  final Function callback;
  
  MyIcon({this.size, @required this.icon, this.callback});

  @override
  _MyIconState createState() => _MyIconState();
}

class _MyIconState extends State<MyIcon> {
  /// Indicates if it's been shown
  bool _visible = true;
  /// Duration of the animation
  int duration = 500;
  /// Path of the icons folder
  final String _path = 'assets/icons/';
  /// Extension of the assets
  final String _suffix = '.png';
  /// Final path of the icon
  String get iconPath => '$_path${widget.icon}$_suffix';


  @override
  Widget build(BuildContext context) {
    // Gesture detector to execute the callback
    return GestureDetector(
      onTap: execute,
      // Makes the icon invisible after clicked.
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: duration),
        child: Container(
            width: widget.size,
            height: widget.size,
            child: Image(color: colorIcon, image: AssetImage(iconPath))),
      ),
    );
  }

  /// Makes the icon invisible, executes the callback and then makes it visible again
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
