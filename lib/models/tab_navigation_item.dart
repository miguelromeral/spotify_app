import 'package:ShareTheMusic/screens/mysettings_screen.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ShareTheMusic/screens/home/home_screen.dart';
import 'package:ShareTheMusic/screens/savedtracks/savedtracks_screen.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> items(SpotifyService state) => [
        TabNavigationItem(
          page: HomeScreen(),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        /*TabNavigationItem(
          page: SearchUserScreen(),
          icon: Icon(Icons.tag_faces),
          title: Text("Users"),
        ),*/
        TabNavigationItem(
          page: SavedTracksScreen(),
          icon: Icon(Icons.music_note),
          title: Text("Saved Songs"),
        ),
        TabNavigationItem(
          page: UserProfileScreen(user: state.myUser,),
          icon: Icon(Icons.face),
          title: Text("Profile"),
        ),
        TabNavigationItem(
          page: MySettingsScreen(),
          icon: Icon(Icons.settings),
          title: Text("Settings"),
        ),
      ];
}
