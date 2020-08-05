/*import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/following/all_users_screen.dart';
import 'package:ShareTheMusic/screens/mysuggestions/mysuggestions_screen.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) => Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildHeader(state),
                  /*ListTile(
                  title: Text('My Playlists'),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPlaylistsScreen()),
                    );
                  },
                ),*/
                  /*ListTile(
                    title: Text('Search Users'),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchUserScreen()),
                      );
                    },
                  ),*/
                  ListTile(
                    title: Text('All Users'),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllUsersScreen()),
                      );
                    },
                  ),
                  /*ListTile(
                  title: Text('My Profile'),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfileScreen(user: state.myUser,)),
                    );
                  },
                ),*/
                  ListTile(
                    title: Text('My Suggestions'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MySuggestionsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                color: colorSemiBackground,
                child: ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    BlocProvider.of<SpotifyBloc>(context).add(LogoutEvent());

                    BlocProvider.of<ApiBloc>(context)
                        .add(UpdateApiEvent(newOne: null));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SpotifyService state) {
    if (state.myUser != null) {
      return GestureDetector(
        onTap: () async {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                        user: state.myUser,
                      )));
        },
        child: UserAccountsDrawerHeader(
          otherAccountsPictures: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MySettingsScreen()),
                );
              },
            )
          ],
          accountName: Text(state.myUser.displayName),
          accountEmail: Text(state.myUser.email),
          currentAccountPicture: ProfilePicture(user: state.myUser),
        ),
      );
    } else {
      return DrawerHeader(
        child: Text('Loading User...'),
        /*decoration: BoxDecoration(
                    color: Colors.blue,
                  ),*/
      );
    }
  }
}
*/