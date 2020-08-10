import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

/// Votes for a suggestion
class PopupItemVote extends PopupItemBase {
  /// Suggestion to vote for
  Suggestion suggestion;

  /// Track referenced in the suggestion
  Track track;

  /// Service to do the callback
  SpotifyService state;

  PopupItemVote({this.suggestion, this.track, this.state})
      : super(
          icon: 'vote',
          text: 'Vote!',
        );

  @override
  void execute(BuildContext context) async {
    await FirestoreService.vote(context, state, suggestion, track);
  }
}
