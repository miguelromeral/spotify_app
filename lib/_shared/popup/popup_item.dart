import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopupActionType { listen, vote, tosuggestion, openuser }

class PopupItem {
  Track track;
  Suggestion suggestion;
  PopupActionType action;
  UserPublic user;

  PopupItem({this.track, this.suggestion, this.user, @required this.action});

  static PopupMenuItem<PopupItem> createOpenUserOption(UserPublic user) {
    return createOption(PopupActionType.openuser, 'See Spotify Profile', 'user',
        null, null, user);
  }

/*
  static PopupMenuItem<PopupItem> createFollowUserOption(
      UserPublic user, bool currentlyFollowing) {
    String title = currentlyFollowing ? 'Unfollow' : 'Follow User';
    String icon = currentlyFollowing ? 'heart_filled' : 'heart_empty';
    return createOption(
        PopupActionType.followuser, title, icon, null, null, user);
  }
*/
  static PopupMenuItem<PopupItem> createSuggestionOption(Track track) {
    return createOption(PopupActionType.tosuggestion, 'Update Suggestion',
        'add', track, null, null);
  }

  static PopupMenuItem<PopupItem> createListenOption(Track track) {
    return createOption(PopupActionType.listen, 'Listen in Spotify', 'spotify',
        track, null, null);
  }

  static PopupMenuItem<PopupItem> createVoteOption(
      Track track, Suggestion suggestion) {
    return createOption(
        PopupActionType.vote, 'Vote!', 'vote', track, suggestion, null);
  }

  static PopupMenuItem<PopupItem> createOption(
      PopupActionType value,
      String text,
      String icon,
      Track track,
      Suggestion suggestion,
      UserPublic user) {
    return PopupMenuItem(
      value: PopupItem(
          track: track, suggestion: suggestion, user: user, action: value),
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

  Future openUser() async {
    if (action == PopupActionType.openuser) {
      openUrl(user.uri);
    }
  }

  Future openTrack() async {
    if (action == PopupActionType.listen) {
      openUrl(track.uri);
    }
  }
/*
  Future vote(BuildContext context, SpotifyService state) async {
    if (state.db.firebaseUserID != suggestion.fuserid) {
      await state.db.likeSuggestion(suggestion);

      //bloc.add(UpdateFeed());
      UpdatedFeedNotification().dispatch(context);

      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('You liked "${track.name}"!')));
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
    }
  }*/
}
