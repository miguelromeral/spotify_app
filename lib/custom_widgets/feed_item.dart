import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';

import 'album_picture.dart';

class FeedItem extends StatelessWidget {
  Track track;
  UserPublic user;
  Suggestion suggestion;

  FeedItem({this.track, this.user, this.suggestion});

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;
    
    String elapsed = timeago.format(suggestion.date, locale: 'en_short');
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
      subtitle: Text(
          '${track.name} - ${track.artists[0].name}\n${suggestion.text}\n' +
              '$elapsed\nLikes: ${suggestion.likes}'),
      isThreeLine: true,
      onTap: () async {
        await state.db.likeSuggestion(suggestion);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('You liked ${track.name}!')));
      },
      onLongPress: () async {
        if (await canLaunch(track.uri)) {
          print("Opening ${track.uri}");
          launch(track.uri);
        }
      },
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
