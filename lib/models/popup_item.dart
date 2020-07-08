import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopupActionType { listen, vote, tosuggestion }

class PopupItem {
  Track track;
  Suggestion suggestion;
  PopupActionType action;

  PopupItem({this.track, this.suggestion, @required this.action});

  static PopupMenuItem<PopupItem> createSuggestionOption(Track track) {
    return createOption(PopupActionType.tosuggestion, 'Update Suggestion',
        'add', track, null);
  }

  static PopupMenuItem<PopupItem> createListenOption(Track track) {
    return createOption(PopupActionType.listen, 'Listen in Spotify',
        'spotify', track, null);
  }

  static PopupMenuItem<PopupItem> createVoteOption(
      Track track, Suggestion suggestion) {
    return createOption(
        PopupActionType.vote, 'Vote!', 'vote', track, suggestion);
  }

  static PopupMenuItem<PopupItem> createOption(PopupActionType value,
      String text, String icon, Track track, Suggestion suggestion) {
    return PopupMenuItem(
      value: PopupItem(track: track, action: value),
      child: Row(
        children: <Widget>[
          //Icon(icon),
          MyIcon(
            icon: icon,
            size: 20.0,
          ),
          SizedBox(
            width: 6.0,
          ),
          Text(text),
        ],
      ),
    );
  }

  Future updateSuggestion(BuildContext context) async {
    if (action == PopupActionType.tosuggestion) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShareTrack(track: track)),
      );
    }
  }
}
