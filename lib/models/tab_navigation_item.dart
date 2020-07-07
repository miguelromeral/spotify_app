import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_app/screens/following/following_screen.dart';
import 'package:spotify_app/screens/home/home_screen.dart';
import 'package:spotify_app/screens/profile/profile_screen.dart';
import 'package:spotify_app/screens/library/savedtracks_screen.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomeScreen(),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        TabNavigationItem(
          page: FollowingScreen(),
          icon: Icon(Icons.tag_faces),
          title: Text("Users"),
        ),
        TabNavigationItem(
          page: SavedTracksScreen(),
          icon: Icon(Icons.music_note),
          title: Text("Saved Songs"),
        ),
        TabNavigationItem(
          page: ProfileScreen(),
          icon: Icon(Icons.face),
          title: Text("Profile"),
        ),
      ];
}
