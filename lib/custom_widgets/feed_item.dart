import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/models/suggestion.dart';

import 'album_picture.dart';

class FeedItem extends StatelessWidget {
  Track track;
  UserPublic user;

  FeedItem({this.track, this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePicture(
        user: user,
        size: 50.0,
      ),
      trailing: AlbumPicture(
        track: track,
        size: 50.0,
      ),
      title: Text(user.displayName),
      subtitle: Text('${track.name}\n${track.artists[0].name}'),
      isThreeLine: true,
    );
/*
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                constraints: BoxConstraints(
                  maxHeight: 100.0,
                  maxWidth: 100.0,
                ),
                color: Colors.red,
                child: Center(
                  child: ProfilePicture(
                    user: user,
                    size: 60.0,
                  ),
                )),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName),
                  Text(track.name),
                  Text(track.artists[0].name),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: 50.0,
                  maxWidth: 50.0,
                ),
                color: Colors.green,
                child: AlbumPicture(
                  track: track,
                  size: 50.0,
                )),
          ),
        ],
      ),
    );*/
  }
}
