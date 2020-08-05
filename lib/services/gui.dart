import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/screens/following/all_users_screen.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:intl/intl.dart';
import 'package:search_app_bar/search_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

Future vote(BuildContext context, SpotifyService state, Suggestion suggestion,
    Track track) async {
  if (state.demo) {
    showMyDialog(context, "You can't Vote Songs in DEMO",
        "Please, log in with Spotify if you want to vote for this song.");
  } else {
    if (!state.firebaseUserIdEquals(suggestion.fuserid)) {
      await state.likeSuggestion(suggestion);

      UpdatedFeedNotification().dispatch(context);

      //Scaffold.of(context).showSnackBar(SnackBar(content: Text('You liked "${track.name}"!')));
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
    }
  }
}

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

TextStyle styleFeedTitle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

TextStyle styleFeedAgo = TextStyle(
  color: Colors.white38,
  fontStyle: FontStyle.italic,
  fontSize: 10.0,
  fontWeight: FontWeight.normal,
);

TextStyle styleFeedTrack = TextStyle(
  color: Colors.green[600],
);

TextStyle styleFeedArtist = TextStyle(
  color: Colors.green[900],
);

TextStyle styleFeedContent = TextStyle(
  fontSize: 16.0,
);

TextStyle styleCardHeader =
    TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);
TextStyle styleCardContent =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

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

int averagePopularity(List<Track> list) {
  if (list.length == 0) return 0;
  int total = 0;
  for (var t in list) {
    total += t.popularity;
  }
  return (total / list.length).truncate();
}

int differentArtists(List<Track> list) {
  List<String> artists = List();
  for (var t in list) {
    for (var a in t.artists) {
      if (!artists.contains(a.name)) {
        artists.add(a.name);
      }
    }
  }
  return artists.length;
}

int differentAlbums(List<Track> list) {
  List<String> albums = List();
  for (var t in list) {
    if (!albums.contains(t.album.id)) {
      albums.add(t.album.id);
    }
  }
  return albums.length;
}

int totalDuration(List<Track> list) {
  int total = 0;
  for (var t in list) {
    total += t.durationMs;
  }
  return total;
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

Widget widgetHeaderTrackList(List<Track> list) {
  return (list != null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              createRowData(
                  "Tracks",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(list.length)}")),
              SizedBox(
                height: 4.0,
              ),
              createRowData(
                  "Artists",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(differentArtists(list))}",
                      style: TextStyle(color: colorAccent))),
              SizedBox(
                height: 4.0,
              ),
              createRowData(
                  "Albums",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(differentAlbums(list))}",
                      style: TextStyle(color: colorAccent))),
              SizedBox(
                height: 4.0,
              ),
              createRowData("Duration",
                  Text("${printDuration(totalDuration(list), true)}")),
              SizedBox(
                height: 4.0,
              ),
              (Settings.getValue<bool>(settingsTrackPopularity, true)
                  ? createRowData(
                      "Av. Popularity",
                      Text(
                        "${averagePopularity(list)} %",
                        style: TextStyle(color: Colors.grey),
                      ))
                  : Container()),
            ])
      : Container());
}

Widget widgetHeaderPlaylistsList(List<PlaylistSimple> list, UserPublic me) {
  return (list != null && me != null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              createRowData(
                  "Playlists",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(list.length)}")),
              SizedBox(
                height: 4.0,
              ),
              createRowData(
                  "Different Owners",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(differentOwners(list))}",
                      style: TextStyle(color: colorAccent))),
              SizedBox(
                height: 4.0,
              ),
              createRowData(
                  "🔒 Private",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(playlistsPrivate(list))}",
                      style: TextStyle(color: colorAccent))),
              SizedBox(
                height: 4.0,
              ),
              createRowData(
                  "🔘 Collab.",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(playlistsCollab(list))}",
                      style: TextStyle(color: colorAccent))),
              SizedBox(
                height: 4.0,
              ),
              createRowData(
                  "Created by me",
                  Text(
                      "${NumberFormat("#,###", "en_US").format(playlistsMine(list, me))}",
                      style: TextStyle(color: colorAccent))),
              SizedBox(
                height: 4.0,
              ),
            ])
      : Container());
}

int differentOwners(List<PlaylistSimple> list) {
  List<String> matches = List();
  for (var t in list) {
    if (!matches.contains(t.owner.id)) {
      matches.add(t.owner.id);
    }
  }
  return matches.length;
}

int playlistsPrivate(List<PlaylistSimple> list) {
  int total = 0;
  for (var t in list) {
    if (!t.public) {
      total++;
    }
  }
  return total;
}

String getArtists(Track track) {
  var str = track.artists.map((e) => e.name).toString();
  return str.substring(1, str.length - 1);
}

int playlistsCollab(List<PlaylistSimple> list) {
  int total = 0;
  for (var t in list) {
    if (t.collaborative) {
      total++;
    }
  }
  return total;
}

int playlistsMine(List<PlaylistSimple> list, UserPublic me) {
  int total = 0;
  for (var t in list) {
    if (t.owner.id == me.id) {
      total++;
    }
  }
  return total;
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
