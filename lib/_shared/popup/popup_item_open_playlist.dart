import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/gui.dart';

// Opens a playlist in Spotify
class PopupItemOpenPlaylist extends PopupItemBase {
  PlaylistSimple playlist;

  PopupItemOpenPlaylist({@required this.playlist})
      : super(
          icon: 'spotify',
          text: 'Open in Spotify',
        );

  @override
  void execute(BuildContext context) async {
    openUrl(playlist.uri);
  }
}
