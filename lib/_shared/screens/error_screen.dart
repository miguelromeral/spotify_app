import 'package:flutter/material.dart';
import 'package:ShareTheMusic/_shared/custom_listtile.dart';
import 'package:ShareTheMusic/screens/styles.dart';

/// Show an error in the current screen
class ErrorScreen extends StatelessWidget {
  /// Title of the error
  final String title;

  /// Text below the main title
  final List<String> stringBelow;

  /// Text collapsed in a part of the screen, not being in the whole screen
  final bool collapsed;

  /// Include a safe area around the content
  final bool safeArea;

  ErrorScreen({
    Key key,
    this.title,
    this.stringBelow,
    this.safeArea,
    this.collapsed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the cotent with a safe area in case it's needed
    if (safeArea != null && safeArea) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildContent(context),
        ),
      );
    } else {
      return _buildContent(context);
    }
  }


  /// Build the text content of the screen
  Widget _buildContent(BuildContext context) {
    if (collapsed) {
      // If collapsed, show like a list tile
      return CustomListTile(
        key: GlobalKey(),
        leadingIcon: Text(
          emoji,
          style: _styleErrorIconCollapsed,
        ),
        content: [
          Text(
            mainTitle,
            style: _styleErrorTitle,
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getContentBelow()),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: _styleErrorIconBig,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                mainTitle,
                style: _styleErrorTitle,
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(children: _getContentBelow()),
            ],
          ),
        ),
      );
    }
  }

  /// Title of the screen. If not provided, added the default one
  String get mainTitle => title ?? "We've had experience some errors.";

  /// Show below the main title a list of the other details of the error
  List<Widget> _getContentBelow() {
    if (stringBelow == null) {
      return List();
    } else {
      return stringBelow
          .map((e) => Text(
                e,
                style: _styleErrorBellow,
                textAlign: TextAlign.center,
              ))
          .toList();
    }
  }

  /// Icon to show in the error screen
  String emoji = '🥺';

  final TextStyle _styleErrorTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: colorError,
  );
  
  final TextStyle _styleErrorBellow = TextStyle(
    fontSize: 16.0,
    color: colorErrorDetail,
  );

  final TextStyle _styleErrorIconBig = TextStyle(
    fontSize: 60.0,
  );

  final TextStyle _styleErrorIconCollapsed = TextStyle(
    fontSize: 40.0,
  );
}
