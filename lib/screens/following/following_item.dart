import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/popup_item.dart';
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
  final GlobalKey _menuKey = new GlobalKey();

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
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Container(
          key: Key(widget.user.id),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                //color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        //color: Colors.black,
                        child: ProfilePicture(
                          user: widget.user,
                          size: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            //SizedBox(height: 4.0),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            _followingIcon(state),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _createBottomBar(context, state, widget.user),
            ],
          ),
        );
      },
    );
  }

  Widget _createBottomBar(
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
    list.add(PopupMenuButton<PopupItem>(
        key: _menuKey,
        onSelected: (PopupItem value) async {
          switch (value.action) {
            case PopupActionType.followuser:
              if (state.db.firebaseUserID != widget.following.fuserid) {
                if (currentlyFollowing) {
                  await state.db.removeFollowing(widget.myFollowings, user.id);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content:
                          Text('You no longer follow ${user.displayName}!')));
                } else {
                  await state.db.addFollowing(widget.myFollowings, user.id);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('You followed ${user.displayName}!')));
                }

                BlocProvider.of<SpotifyBloc>(context).add(UpdateFeed());
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('You Can Not Vote For Your Own Song.')));
              }
              break;
            case PopupActionType.openuser:
              value.openUser();
              break;
            default:
              break;
          }
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: MyIcon(
            icon: 'menu',
            size: 20.0,
            callback: () {
              dynamic tmp = _menuKey.currentState;
              tmp.showButtonMenu();
            },
          ),
        ),
        itemBuilder: (BuildContext context) => _getActions(widget.user)));

    return Container(
      //color: Colors.blue[300],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: list,
      ),
    );
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

  List<PopupMenuItem<PopupItem>> _getActions(UserPublic user) {
    List<PopupMenuItem<PopupItem>> list = List();

    list.add(PopupItem.createFollowUserOption(user, currentlyFollowing));
    list.add(PopupItem.createOpenUserOption(user));
/*    if (suggestion.suserid != mySpotifyUserId) {
      list.add(PopupItem.createVoteOption(track, suggestion));
    }*/
    return list;
  }
}
