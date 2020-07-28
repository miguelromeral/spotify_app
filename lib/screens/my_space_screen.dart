import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/blocs/playlists_bloc.dart';
import 'package:ShareTheMusic/blocs/saved_tracks_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'following/all_users_screen.dart';
import 'mysuggestions/mysuggestions_screen.dart';

class MySpaceScreen extends StatefulWidget {
  @override
  _MySpaceScreenState createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends State<MySpaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(20.0), child: _buildBody(context))),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) => Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildHeader(state),
                SizedBox(
                  height: 8.0,
                ),
                _buildSection(context, 'Discover Users', [
                  /*_createTile(context, "Search Users", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchUserScreen()),
                    );
                  }, 'searchuser'),
                  SizedBox(
                    height: 8.0,
                  ),*/
                  _createTile(context, "All Users", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllUsersScreen()),
                    );
                  }, 'allusers'),
                ]),
                _buildSection(context, 'Your Activity', [
                  _createTile(context, "My Suggestions", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MySuggestionsScreen()),
                    );
                  }, 'mysugs'),
                ]),
              ],
            ),
          ),
          Expanded(
              flex: 0,
              child: _createTile(context, 'Logout', () {
                BlocProvider.of<SpotifyBloc>(context).add(LogoutEvent());

                BlocProvider.of<HomeBloc>(context)
                    .add(UpdateFeedHomeEvent(suggestions: List()));

                BlocProvider.of<SavedTracksBloc>(context)
                    .add(UpdateSavedTracksEvent(newOne: List()));

                BlocProvider.of<PlaylistsBloc>(context)
                    .add(UpdatePlaylistsEvent(newOne: List()));

                BlocProvider.of<ApiBloc>(context)
                    .add(UpdateApiEvent(newOne: null));
              }, 'logout')),
        ],
      ),
    );
  }

  Container _buildSection(
      BuildContext context, String title, List<Widget> widgets) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: colorPrimary.withAlpha(50),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          children: List.unmodifiable(() sync* {
            yield Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: styleCardContent,
              ),
            );
            yield SizedBox(
              height: 8.0,
            );
            yield* widgets;
          }()),
        ),
      ),
    );
  }

  Container _createTile(
      BuildContext context, String text, Function callback, String icon) {
    return Container(
        decoration: BoxDecoration(
          color: colorBackground.withAlpha(80),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: (icon != null
            ? ListTile(
                leading: MyIcon(icon: icon, size: 20.0),
                title: Center(child: Text(text)),
                onTap: () async {
                  callback.call();
                },
                trailing: Text(''),
              )
            : ListTile(
                title: Center(child: Text(text)),
                onTap: () async {
                  callback.call();
                },
              )));
  }

  Widget _buildHeader(SpotifyService state) {
    return Container(
      decoration: BoxDecoration(
        color: colorAccent.withAlpha(50),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                        user: state.myUser,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (state.myUser != null
              ? _createHeaderUser(state)
              : _createHeaderNoUser(state)),
        ),
      ),
    );
  }

  Widget _createHeaderUser(SpotifyService state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfilePicture(
                user: state.myUser,
                size: 100.0,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySettingsScreen()),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            state.myUser.displayName,
            style: styleCardContent,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            state.myUser.email,
            style: styleCardHeader,
          ),
        ],
      ),
    );
  }

  Widget _createHeaderNoUser(SpotifyService state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Unknown User'),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MySettingsScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
