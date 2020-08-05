import 'package:flutter/material.dart';

/// Widget that shows the App Logo
class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage('assets/icons/app.png'));
  }
}
