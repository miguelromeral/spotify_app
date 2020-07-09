import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/popup/popup_item_base.dart';
import 'package:spotify_app/services/gui.dart';

class PopupItemOpenUser extends PopupItemBase {
  UserPublic user;

  PopupItemOpenUser({this.user})
      : super(
          icon: 'user',
          text: 'See Spotify Profile',
        );

  @override
  void execute(BuildContext context) async {
    openUrl(user.uri);
  }
}
