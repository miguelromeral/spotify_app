import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/services/styles.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/services/gui.dart';

import '../myicon.dart';

/// Button that allow user to follow new users in the app
class FollowingButton extends StatefulWidget {
  final Key key;

  /// Spotify User to follow
  final UserPublic user;

  /// Following info of this user
  final Following userFollowing;

  /// My following info
  final Following myFollowings;

  FollowingButton({this.key, this.user, this.myFollowings, this.userFollowing});

  @override
  _FollowingButtonState createState() => _FollowingButtonState();
}

class _FollowingButtonState extends State<FollowingButton> {
  @override
  Widget build(BuildContext context) {
    // You can't unfollow/follow yourself. empty space instead
    if (widget.myFollowings.fuserid == widget.userFollowing.fuserid) {
      return Container();
    }
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        var size = 27.0;
        // Currently following user
        if (widget.myFollowings.containsUser(widget.user.id)) {
          return RaisedButton.icon(
            textColor: Colors.black,
            shape: buttonShape,
            onPressed: () {
              _followUnfollow(
                  state,
                  context,
                  BlocProvider.of<HomeBloc>(context),
                  BlocProvider.of<SpotifyBloc>(context));
            },
            icon: MyIcon(
              icon: 'heart_filled',
              size: size,
            ),
            label: Text('Unfollow'),
          );
        } else {
          // Currently NOT following user
          return RaisedButton.icon(
            color: colorPrimary,
            shape: buttonShape,
            onPressed: () {
              _followUnfollow(
                  state,
                  context,
                  BlocProvider.of<HomeBloc>(context),
                  BlocProvider.of<SpotifyBloc>(context));
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

  Future _followUnfollow(SpotifyService state, BuildContext context,
      HomeBloc hb, SpotifyBloc sb) async {
    // Ensure to follow a different user
    if (!state.firebaseUserIdEquals(widget.userFollowing.fuserid)) {
      // Currently following:
      if (widget.myFollowings.containsUser(widget.user.id)) {
        await state.removeFollowing(widget.myFollowings, widget.user.id);
        print("Unfollowing ${widget.user.id}");
      } else {
        // Currently NOT following:
        await state.addFollowing(widget.myFollowings, widget.user.id);
        print("Following ${widget.user.id}");
      }

      // Update app state avoiding the user to refresh
      sb.add(UpdateFollowing());
      hb.add(UpdateFeedHomeEvent(suggestions: await state.getsuggestions()));
      print("Updated Following and Feed From Following Button");
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Unfollow Yourself!')));
    }
  }
}
