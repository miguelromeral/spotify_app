import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/_shared/custom_listtile.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/popup/popup_item.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class FollowingItem extends StatefulWidget {
  final Following myFollowings;
  final Following following;
  final UserPublic user;

  FollowingItem({this.myFollowings, this.following, this.user});

  @override
  _FollowingItemState createState() => _FollowingItemState();
}

class _FollowingItemState extends State<FollowingItem> {
  bool liked;

  bool get currentlyFollowing =>
      widget.myFollowings.usersList.contains(widget.user.id);

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
      return CustomListTile(
        key: Key(widget.user.id),
        leadingIcon: ProfilePicture(
          user: widget.user,
          size: 50.0,
        ),
        trailingIcon: _followingIcon(state),
        content: _createContent(),
        bottomIcons: _createBottomBar(context, state, widget.user),
        menuItems: _getActions(state, widget.user),
      );
    });
  }

  List<Widget> _createContent() {
    return [
      Container(
        //color: Colors.green,
        child: Text(
          widget.user.displayName,
          style: styleFeedTitle,
        ),
      ),
      SizedBox(height: 4.0),
      Container(
        //color: Colors.yellow[100],
        child: Text(
          "ID: ${widget.user.id}",
          style: styleFeedTrack,
        ),
      ),
    ];
  }

  List<Widget> _createBottomBar(
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
        Text('Following: ${widget.following.followingCount}'),
      ],
    ));
    list.add(Row(
      children: [
        MyIcon(
          icon: 'user_broadcast',
          size: 20.0,
        ),
        SizedBox(
          width: 4.0,
        ),
        Text('Followers: ${widget.following.followedBy}'),
      ],
    ));
    return list;
  }

  Widget _followingIcon(SpotifyService state) {
    var size = 27.0;
    if (currentlyFollowing) {
      return MyIcon(
        icon: 'heart_filled',
        size: size,
        callback: () {
          _followUnfollow(state);
        },
      );
    } else {
      return MyIcon(
        icon: 'heart_empty',
        size: size,
        callback: () {
          _followUnfollow(state);
        },
      );
    }
  }

  Future _followUnfollow(SpotifyService state) async {
    if (state.db.firebaseUserID != widget.following.fuserid) {
      if (currentlyFollowing) {
        await state.db.removeFollowing(widget.myFollowings, widget.user.id);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You no longer follow ${widget.user.displayName}!')));
      } else {
        await state.db.addFollowing(widget.myFollowings, widget.user.id);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You followed ${widget.user.displayName}!')));
      }

      BlocProvider.of<SpotifyBloc>(context).add(UpdateFeed());
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
    }
  }

  List<PopupMenuItem<PopupItem>> _getActions(SpotifyService state, UserPublic user) {
    List<PopupMenuItem<PopupItem>> list = List();

//    list.add(PopupItem.createFollowUserOption(user, currentlyFollowing, _followUnfollowCallback(state)));
    list.add(PopupItem.createOpenUserOption(user));
    return list;
  }
}
