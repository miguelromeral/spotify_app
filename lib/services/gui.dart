import 'package:ShareTheMusic/screens/following/all_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

Future vote(BuildContext context, SpotifyService state, Suggestion suggestion,
    Track track) async {
  if (!state.firebaseUserIdEquals(suggestion.fuserid)) {
    await state.likeSuggestion(suggestion);

    UpdatedFeedNotification().dispatch(context);

    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('You liked "${track.name}"!')));
  } else {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
  }
}

void NavigateAllUsers(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AllUsersScreen()),
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

String printDuration(int ms) {
  Duration duration = Duration(milliseconds: ms);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  return "$twoDigitMinutes:$twoDigitSeconds";
}
