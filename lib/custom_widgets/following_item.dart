import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/following_list.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/notifications/SuggestionLikeNotification.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';

import 'album_picture.dart';

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

  bool get currentlyFollowing => widget.myFollowings.usersList.contains(widget.user.id);

  @override
  void initState() {
    liked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    var user = widget.user;
    var following = widget.following;

    return ListTile(
      leading: ProfilePicture(
        user: user,
        size: 50.0,
      ),
      title: Text(user.displayName),
      isThreeLine: true,
      trailing: _followingIcon(),
      subtitle:
          Text('ID: ${user.id}\nFollowing: ${following.usersList.length}'),
      onTap: () async {
        if (state.db.firebaseUserID != following.fuserid) {

          await state.db.addFollowing(user.id);

          bloc.add(UpdateFollowing());

          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('You followed ${user.displayName}!')));
        }else{
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
        }
      },
      /*onLongPress: () async {
        if (await canLaunch(track.uri)) {
          print("Opening ${track.uri}");
          launch(track.uri);
        }
      },*/
    );
  }

  Widget _followingIcon() {
    if (currentlyFollowing) {
      return Icon(Icons.check_circle);
    } else {
      return Icon(Icons.panorama_fish_eye);
    }
  }
}
