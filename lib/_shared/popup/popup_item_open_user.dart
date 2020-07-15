import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/gui.dart';

class PopupItemOpenUser extends PopupItemBase {
  UserPublic user;

  PopupItemOpenUser({this.user})
      : super(
          icon: 'spotify',
          text: 'See Spotify Profile',
        );

  @override
  void execute(BuildContext context) async {
    openUrl(user.uri);
  }
}
