import 'package:ShareTheMusic/_shared/following/following_button.dart';
import 'package:ShareTheMusic/screens/styles.dart';
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

class FollowingItem extends StatefulWidget {
  final Following myFollowings;
  //final Following following;
  final String suserid;

  FollowingItem({this.myFollowings, /*this.following,*/ this.suserid});

  @override
  _FollowingItemState createState() => _FollowingItemState();
}

class _FollowingItemState extends State<FollowingItem> {
  bool liked;

  bool get currentlyFollowing =>
      widget.myFollowings.usersList.contains(widget.suserid);

  @override
  void initState() {
    liked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _newListTile(context);
  }

  Widget _newListTile(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return FutureBuilder(
        future: state.getFollowingBySpotifyUserID(widget.suserid),
        builder: (context, snp) {
          // TODO: check if null
          Following fol = snp.data;
          if (fol == null) return Text('Fol null in FollowingItem');
          return FutureBuilder(
              future: state.api.users.get(widget.suserid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserPublic user = snapshot.data;
                  return CustomListTile(
                    key: Key(widget.suserid),
                    leadingIcon: ProfilePicture(
                      user: user,
                      size: 50.0,
                    ),
                    trailingIcon: FollowingButton(
                      key: new GlobalKey(),
                      myFollowings: widget.myFollowings,
                      user: user,
                      userFollowing: fol,
                    ),
                    content: _createContent(user),
                    bottomIcons: _createBottomBar(fol, context, state, user),
                    menuItems: _getActions(state, user),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        },
      );
    });
  }

  List<Widget> _createContent(UserPublic user) {
    return [
      Container(
        //color: Colors.green,
        child: Text(
          user.displayName,
          style: styleFeedTitle,
        ),
      ),
      SizedBox(height: 4.0),
      Container(
        //color: Colors.yellow[100],
        child: Text(
          "ID: ${widget.suserid}",
          style: styleFeedTrack,
        ),
      ),
    ];
  }

  List<Widget> _createBottomBar(Following fol, BuildContext context,
      SpotifyService state, UserPublic user) {
    List<Widget> list = List();

    list.add(Row(
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
    ));
    /*list.add(Row(
      children: [
        MyIcon(
          icon: 'user_broadcast',
          size: 20.0,
        ),
        SizedBox(
          width: 4.0,
        ),
        Text('Followers: ${fol.followedBy}'),
      ],
    ));*/
    return list;
  }

  List<PopupMenuItem<PopupItemBase>> _getActions(
      SpotifyService state, UserPublic user) {
    List<PopupMenuItem<PopupItemBase>> list = List();

//    list.add(PopupItem.createFollowUserOption(user, currentlyFollowing, _followUnfollowCallback(state)));
    list.add(PopupItemOpenUser(user: user).create());
    list.add(PopupItemOpenProfile(user: user).create());
    return list;
  }
}
