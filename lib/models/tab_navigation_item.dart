import 'package:ShareTheMusic/screens/demo/home_demo.dart';
import 'package:ShareTheMusic/screens/demo/more_screen.dart';
import 'package:ShareTheMusic/screens/demo/tracks_demo.dart';
import 'package:ShareTheMusic/screens/my_space_screen.dart';
import 'package:ShareTheMusic/screens/playlists/my_playlists_screen.dart';
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

  static List<TabNavigationItem> items() {
    return [
      TabNavigationItem(
        page: PageStorage(
          child: new HomeScreen(),
          bucket: new PageStorageBucket(),
          key: HomeScreen.pageKey,
        ),
        icon: Icon(Icons.home),
        title: Text("Home"),
      ),
      /*TabNavigationItem(
          page: SearchUserScreen(),
          icon: Icon(Icons.tag_faces),
          title: Text("Users"),
        ),*/
      TabNavigationItem(
        page: MyPlaylistsScreen(),
        icon: Icon(Icons.library_music),
        title: Text("Playlists"),
      ),
      TabNavigationItem(
        page: SavedTracksScreen(),
        icon: Icon(Icons.music_note),
        title: Text("Saved Songs"),
      ),
      TabNavigationItem(
        page: MySpaceScreen(),
        icon: Icon(Icons.record_voice_over),
        title: Text("My Space"),
      ),
      /*TabNavigationItem(
          page: UserProfileScreen(
            user: state.myUser,
          ),
          icon: Icon(Icons.face),
          title: Text("Profile"),
        ),*/

      /*   TabNavigationItem(
          page: MySettingsScreen(),
          icon: Icon(Icons.settings),
          title: Text("Settings"),
        ),*/
    ];
  }

  static List<TabNavigationItem> itemsDemo(/*SpotifyApi api*/) => [
        /*TabNavigationItem(
          page: Text('Test'),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),*/
        TabNavigationItem(
          page: HomeScreenDemo(),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        
        TabNavigationItem(
          page: SavedTracksDemo(/*api: api*/),
          icon: Icon(Icons.music_note),
          title: Text("Saved Songs"),
        ),
        TabNavigationItem(
          page: DemoMoreScreen(),
          icon: Icon(Icons.add),
          title: Text("More"),
        ),
      ];
}
