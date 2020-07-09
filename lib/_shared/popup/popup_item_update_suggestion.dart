import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/popup/popup_item_base.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';
import 'package:spotify_app/services/gui.dart';

class PopupItemUpdateSuggestion extends PopupItemBase {
  Track track;

  PopupItemUpdateSuggestion({this.track})
      : super(
          icon: 'add',
          text: 'Update Suggestion',
        );

  @override
  void execute(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShareTrack(track: track)),
      );
  }
}
