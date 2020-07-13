import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/popup/popup_item_base.dart';
import 'package:spotify_app/services/gui.dart';

class PopupItemOpenPlaylist extends PopupItemBase {
  PlaylistSimple playlist;

  PopupItemOpenPlaylist({this.playlist})
      : super(
          icon: 'spotify',
          text: 'Open in Spotify',
        );

  @override
  void execute(BuildContext context) async {
    openUrl(playlist.uri);
  }
}