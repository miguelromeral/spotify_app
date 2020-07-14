import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/_shared/custom_listtile.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/_shared/popup/popup_item_open_user.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/popup/popup_item_base.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';

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
        future: state.db.getFollowingBySpotifyUserID(widget.suserid),
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
                    trailingIcon: _followingIcon(fol, user, state),
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


  List<Widget> _createBottomBar(
    Following fol,
      BuildContext context, SpotifyService state, UserPublic user) {
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

  Widget _followingIcon(Following fol, UserPublic user, SpotifyService state) {
    var size = 27.0;
    if (currentlyFollowing) {
      return MyIcon(
        icon: 'heart_filled',
        size: size,
        callback: () {
          _followUnfollow(fol, user, state);
        },
      );
    } else {
      return MyIcon(
        icon: 'heart_empty',
        size: size,
        callback: () {
          _followUnfollow(fol, user, state);
        },
      );
    }
  }

  Future _followUnfollow(
      Following fol, UserPublic user, SpotifyService state) async {
    if (state.db.firebaseUserID != fol.fuserid) {
      if (currentlyFollowing) {
        await state.db.removeFollowing(widget.myFollowings, widget.suserid);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You no longer follow ${user.displayName}!')));
      } else {
        await state.db.addFollowing(widget.myFollowings, widget.suserid);
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('You followed ${user.displayName}!')));
      }

      BlocProvider.of<SpotifyBloc>(context).add(UpdateFeed());
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Unfollow Yourself!')));
    }
  }

  List<PopupMenuItem<PopupItemBase>> _getActions(
      SpotifyService state, UserPublic user) {
    List<PopupMenuItem<PopupItemBase>> list = List();

//    list.add(PopupItem.createFollowUserOption(user, currentlyFollowing, _followUnfollowCallback(state)));
    list.add(PopupItemOpenUser(user: user).create());
    return list;
  }
}
