import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/_shared/popup/popup_item_base.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupItemVote extends PopupItemBase {
  Suggestion suggestion;
  Track track;
  SpotifyService state;

  PopupItemVote({this.suggestion, this.track, this.state}) : super(
    icon: 'vote',
    text: 'Vote!',
  );

  @override
  void execute(BuildContext context) async {
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
  }

}
