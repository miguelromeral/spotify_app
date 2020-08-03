import 'package:ShareTheMusic/_shared/following/following_button.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/_shared/custom_listtile.dart';
import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_profile.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_user.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

/// Widget to show Following info for one user
class FollowingItem extends StatefulWidget {
  final Key key;

  /// Following info for the current user
  final Following myFollowings;

  /// Spotify User ID
  final String suserid;

  FollowingItem({this.myFollowings, this.suserid, this.key}) : super(key: key);

  @override
  _FollowingItemState createState() => _FollowingItemState();
}

class _FollowingItemState extends State<FollowingItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, MyApi>(
      builder: (context, api) =>
          BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
        // Get the Firestore data for this user.
        return FutureBuilder(
          future: state.getFollowingBySpotifyUserID(widget.suserid),
          builder: (context, snp) {
            if (snp.hasData) {
              Following fol = snp.data;
              // Once we get our following info, we retrieve the Spotify User info.
              return FutureBuilder(
                  future: api.getUser(widget.suserid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserPublic user = snapshot.data;
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: followingBoxDecoration,
                        child: CustomListTile(
                          key: Key(widget.suserid),
                          // Profile Picture
                          leadingIcon: Container(
                            padding: EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                navigateProfile(context, user);
                              },
                              // Animation for next screen
                              child: Hero(
                                tag: user.id,
                                child: ProfilePicture(
                                  user: user,
                                  size: 60.0,
                                ),
                              ),
                            ),
                          ),
                          // Following button in case it's not your own user.
                          trailingIcon: Container(
                            padding: EdgeInsets.all(2.0),
                            child: FollowingButton(
                              key: new GlobalKey(),
                              myFollowings: widget.myFollowings,
                              user: user,
                              userFollowing: fol,
                            ),
                          ),
                          // Card info
                          content: _createContent(user),
                          // Following info
                          bottomIcons:
                              _createBottomBar(fol, context, state, user),
                          // Menu buttons
                          menuItems: _getActions(state, user),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Not connection with Spotify API for user
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: errorDecoration,
                        child: CustomListTile(
                          leadingIcon: netErrorIcon,
                          content: [
                            Text("Couldn't get info for user:"),
                            Text(widget.suserid),
                          ],
                          key: Key(widget.suserid),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            } else if (snp.hasError) {
              // No single following info retrieved from Firestore
              return ErrorScreen(
                collapsed: true,
                title: 'Not User Following Info',
                stringBelow: ["Please, try again later"],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }

  // Content of the custom tile
  List<Widget> _createContent(UserPublic user) {
    return [
      // Display Name
      Container(
        child: Text(
          user.displayName,
          style: styleFeedTitle,
        ),
      ),
      SizedBox(height: 4.0),
      // Spotify User ID
      Container(
        child: Text(
          "ID: ${widget.suserid}",
          style: styleFeedTrack,
        ),
      ),
    ];
  }

  // Bottom bar to show following info activity
  List<Widget> _createBottomBar(Following fol, BuildContext context,
      SpotifyService state, UserPublic user) {
    return [
      // Number of users who follow
      Row(
        children: [
          MyIcon(
            icon: 'user',
            size: 20.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text('Following: ${fol.followingCount}'),
        ],
      ),

      // Number of followers this user has
      Row(
        children: [
          MyIcon(
            icon: 'user_broadcast',
            size: 20.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          FutureBuilder(
            future: state.getFollowers(user.id),
            builder: (context, snp) {
              String text = '?';
              if (snp.hasData) {
                var list = snp.data;
                text = list.length.toString();
              }
              return Text('Followers: $text');
            },
          ),
        ],
      )
    ];
  }

  // Menu Buttons
  List<PopupMenuItem<PopupItemBase>> _getActions(
      SpotifyService state, UserPublic user) {
    return [
      PopupItemOpenUser(user: user).create(),
      PopupItemOpenProfile(user: user).create(),
    ];
  }
}
