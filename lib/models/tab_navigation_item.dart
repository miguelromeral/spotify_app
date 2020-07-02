import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_app/screens/home.dart';
import 'package:spotify_app/screens/saved_songs.dart';
import 'package:spotify_app/screens/test.dart';

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
          page: SavedSongs(),
          icon: Icon(Icons.music_note),
          title: Text("Saved Songs"),
        ),
      ];
}
