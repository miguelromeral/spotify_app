import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/gui.dart';

// Opens a track in Spotify app
class PopupItemOpenTrack extends PopupItemBase {
  Track track;

  PopupItemOpenTrack({@required this.track})
      : super(
          icon: 'spotify',
          text: 'Listen in Spotify',
        );

  @override
  void execute(BuildContext context) async {
    openUrl(track.uri);
  }
}
