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

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('You liked "${track.name}"!')));
  } else {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
  }
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

final TextStyle styleFeedTitle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

final TextStyle styleFeedAgo = TextStyle(
  color: Colors.white38,
  fontStyle: FontStyle.italic,
);

final TextStyle styleFeedTrack = TextStyle(
  color: Colors.green[600],
);

final TextStyle styleFeedArtist = TextStyle(
  color: Colors.green[900],
);

final TextStyle styleFeedContent = TextStyle(
  fontSize: 16.0,
);

final TextStyle styleCardHeader =
    TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic);
final TextStyle styleCardContent =
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
