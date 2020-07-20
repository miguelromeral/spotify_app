import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class PopupItemVote extends PopupItemBase {
  Suggestion suggestion;
  Track track;
  SpotifyService state;

  PopupItemVote({this.suggestion, this.track, this.state})
      : super(
          icon: 'vote',
          text: 'Vote!',
        );

  @override
  void execute(BuildContext context) async {
    if (state.demo) {
      showMyDialog(context, "You can't Vote Songs in DEMO", "Please, log in with Spotify if you want to vote for this song.");

    } else {
      await vote(context, state, suggestion, track);
    }
  }
}
