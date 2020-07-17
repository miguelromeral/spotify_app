import 'package:flutter/material.dart';
import 'package:ShareTheMusic/_shared/custom_listtile.dart';
import 'package:ShareTheMusic/screens/styles.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final List<Widget> below;
  final List<String> stringBelow;
  final bool collapsed;
  final bool safeArea;

  ErrorScreen({
    Key key,
    this.title,
    this.below,
    this.stringBelow,
    this.safeArea,
    this.collapsed = false,
  }) : super(key: key);

  Widget _buildContent(BuildContext context) {
    if (collapsed) {
      return CustomListTile(
        key: GlobalKey(),
        leadingIcon: Text(
          '🥺',
          style: _styleErrorIconCollapsed,
        ),
        content: [
          Text(
            _getTitle(),
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
                '🥺',
                style: _styleErrorIconBig,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                _getTitle(),
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

  @override
  Widget build(BuildContext context) {
    if (safeArea != null && safeArea) {
      return Scaffold(
        body: SafeArea(
          child: _buildContent(context),
        ),
      );
    } else {
      return _buildContent(context);
    }
  }

  String _getTitle() => title ?? "We've had experience some errors.";

  List<Widget> _getContentBelow() {
    if (below == null) {
      if (stringBelow == null) {
        return [
          Text(
            "We couldn't load this part of the app.",
            style: _styleErrorBellow,
          ),
          Text("Please, try again later.", style: _styleErrorBellow),
        ];
      } else {
        return stringBelow
            .map((e) => Text(e, style: _styleErrorBellow))
            .toList();
      }
    } else {
      return below;
    }
  }

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
