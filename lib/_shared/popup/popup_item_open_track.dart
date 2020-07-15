import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/gui.dart';

class PopupItemOpenTrack extends PopupItemBase {
  Track track;

  PopupItemOpenTrack({this.track})
      : super(
          icon: 'spotify',
          text: 'Listen in Spotify',
        );

  @override
  void execute(BuildContext context) async {
    openUrl(track.uri);
  }
}
