import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/screens/following/all_users_screen.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/services/spotify_stats.dart';
import 'package:ShareTheMusic/services/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:intl/intl.dart';
import 'package:search_app_bar/search_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';


void navigate(BuildContext context, Widget child) {
  Navigator.push(context, FadeRoute(page: child));
}

void navigateAllUsers(BuildContext context) =>
    navigate(context, AllUsersScreen());

void navigateProfile(BuildContext context, UserPublic user) =>
    navigate(context, UserProfileScreen(user: user));


Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

/// https://medium.com/flutter-community/everything-you-need-to-know-about-flutter-page-route-transition-9ef5c1b32823
///
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

void showMyDialog(BuildContext context, String title, String subtitle) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(subtitle),
        actions: <Widget>[
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future openTrackSpotify(Track track) async {
  openUrl(track.uri);
}

Future openUrl(String uri) async {
  if (await canLaunch(uri)) {
    print("Opening $uri");
    launch(uri);
  }
}

const double albumIconSize = 70.0;

String printDuration(int ms, bool showHours) {
  Duration duration = Duration(milliseconds: ms);
  if (showHours) {
    String twoDigits(int n) => n.toString().padLeft(1, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  } else {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

Widget createRowData(String title, Widget content) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          flex: 8,
          child: (title.isNotEmpty
              ? Text(
                  title,
                  style: styleCardHeader,
                  textAlign: TextAlign.right,
                )
              : Container())),
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
        flex: 8,
        child: content,
      ),
    ],
  );
}



RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0),
    side: BorderSide(color: Colors.white));

BoxDecoration followingBoxDecoration = BoxDecoration(
  color: colorAccent.withAlpha(150),
  borderRadius: BorderRadius.circular(20.0),
);

BoxDecoration errorDecoration = BoxDecoration(
  color: colorErrorCard.withAlpha(150),
  borderRadius: BorderRadius.circular(20.0),
);

Widget netErrorIcon = Container(
  padding: EdgeInsets.all(4.0),
  height: 40.0,
  child: MyIcon(
    icon: 'neterror',
  ),
);

InputDecoration getSearchDecoration(String hint) => new InputDecoration(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(100.0),
      ),
      filled: false,
      hintStyle: new TextStyle(color: Colors.grey[800]),
      hintText: hint,
    );

/*
Widget getSearchTextField(
  List list,
  TextEditingController _textController,
  bool _textEmpty,
  String hint,
  SearchBloc sb,
) =>
    (list != null || list.isNotEmpty
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Use all the space for the textfield, but when the
              /// delete icon is shown, let him a little space at the end
              Expanded(
                flex: 1,
                child: TextField(
                  // Use the controller to know when the field is empty
                  controller: _textController,
                  showCursor: true,
                  // Go to the search bloc to use the filters when typped something
                  onChanged: sb.onSearchQueryChanged,

                  decoration: getSearchDecoration(hint),
                ),
              ),

              /// No space allowed to the delete icon but the necessary
              Expanded(
                flex: 0,
                // Only show when the textfield is not empty
                child: (_textEmpty
                    ? Container()
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Clear the entry and reset the criteria to show all the initial list again
                          _textController.clear();
                          sb.onSearchQueryChanged('');
                        },
                      )),
              ),
            ],
          )
        : Container());
*/