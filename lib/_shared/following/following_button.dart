import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/screens/profile/user_profile_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';

import '../myicon.dart';

class FollowingButton extends StatefulWidget {
  final Key key;
  final UserPublic user;
  final Following myFollowings;
  final Following userFollowing;

  FollowingButton({this.key, this.user, this.myFollowings, this.userFollowing});

  @override
  _FollowingButtonState createState() => _FollowingButtonState();
}

class _FollowingButtonState extends State<FollowingButton> {
  bool get currentlyFollowing =>
      widget.myFollowings.usersList.contains(widget.user.id);

  @override
  Widget build(BuildContext context) {
    if (widget.myFollowings.fuserid == widget.userFollowing.fuserid) {
      return Container();
    }
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        var size = 27.0;
        if (currentlyFollowing) {
          return RaisedButton.icon(
            textColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white)),
            onPressed: () async {
              _followUnfollow(state, context);
            },
            icon: MyIcon(
              icon: 'heart_filled',
              size: size,
            ),
            label: Text('Unfollow'),
          );
        } else {
          return RaisedButton.icon(
            color: colorPrimary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white)),
            onPressed: () async {
              _followUnfollow(state, context);
            },
            icon: MyIcon(
              icon: 'heart_empty',
              size: size,
            ),
            label: Text('Follow!'),
          );
        }
      },
    );
  }

  Future _followUnfollow(SpotifyService state, BuildContext context) async {
    if (!state.firebaseUserIdEquals(widget.userFollowing.fuserid)) {
      if (currentlyFollowing) {
        await state.removeFollowing(widget.myFollowings, widget.user.id);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You no longer follow ${widget.user.displayName}!')));
      } else {
        await state.addFollowing(widget.myFollowings, widget.user.id);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You followed ${widget.user.displayName}!')));
      }

      BlocProvider.of<SpotifyBloc>(context).add(UpdateFeed());
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Unfollow Yourself!')));
    }
  }
}
