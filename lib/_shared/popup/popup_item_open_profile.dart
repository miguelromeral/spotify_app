import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';

class PopupItemOpenProfile extends PopupItemBase {

  UserPublic user;

  PopupItemOpenProfile({this.user})
      : super(
          icon: 'user',
          text: 'See Profile',
        );

  @override
  void execute(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserProfileScreen(
                user: user,
              )),
    );
  }
}
