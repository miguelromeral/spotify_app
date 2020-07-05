import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_app/screens/following_screen.dart';
import 'package:spotify_app/screens/home.dart';
import 'package:spotify_app/screens/profile.dart';
import 'package:spotify_app/screens/saved_songs.dart';

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
          page: Home(),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        TabNavigationItem(
          page: FollowingScreen(),
          icon: Icon(Icons.tag_faces),
          title: Text("Users"),
        ),
        TabNavigationItem(
          page: SavedSongs(),
          icon: Icon(Icons.music_note),
          title: Text("Saved Songs"),
        ),
        TabNavigationItem(
          page: Profile(),
          icon: Icon(Icons.face),
          title: Text("Profile"),
        ),
      ];
}
