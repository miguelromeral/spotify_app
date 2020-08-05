import 'package:ShareTheMusic/screens/demo/home_demo.dart';
import 'package:ShareTheMusic/screens/demo/more_screen.dart';
import 'package:ShareTheMusic/screens/demo/tracks_demo.dart';
import 'package:ShareTheMusic/screens/my_space_screen.dart';
import 'package:ShareTheMusic/screens/playlists/my_playlists_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ShareTheMusic/screens/home/home_screen.dart';
import 'package:ShareTheMusic/screens/savedtracks/savedtracks_screen.dart';

/// Class with the info of every bottom menu item
class TabNavigationItem {
  /// Page to display
  final Widget page;

  /// Title of the screen (shown below the icon in the bottom bar)
  final Widget title;

  /// Icon of the item
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  /// Items of the bottom bar in the app
  static List<TabNavigationItem> items = [
    // Home Page
    TabNavigationItem(
      page: PageStorage(
        child: new HomeScreen(),
        bucket: new PageStorageBucket(),
        key: HomeScreen.pageKey,
      ),
      icon: Icon(Icons.home),
      title: Text("Home"),
    ),
    // Playlists page
    TabNavigationItem(
      page: MyPlaylistsScreen(),
      icon: Icon(Icons.library_music),
      title: Text("Playlists"),
    ),
    // Saved Tracks Page
    TabNavigationItem(
      page: SavedTracksScreen(),
      icon: Icon(Icons.music_note),
      title: Text("Saved Songs"),
    ),
    // My Space Page
    TabNavigationItem(
      page: MySpaceScreen(),
      icon: Icon(Icons.record_voice_over),
      title: Text("My Space"),
    ),
  ];

  static List<TabNavigationItem> itemsDemo = [
    // Home Demo Page
    TabNavigationItem(
      page: HomeScreenDemo(),
      icon: Icon(Icons.home),
      title: Text("Home"),
    ),
    // Saved Tracks Demo Page
    TabNavigationItem(
      page: SavedTracksDemo(),
      icon: Icon(Icons.music_note),
      title: Text("Saved Songs"),
    ),
    // More Demo Page
    TabNavigationItem(
      page: DemoMoreScreen(),
      icon: Icon(Icons.add),
      title: Text("More"),
    ),
  ];
}
