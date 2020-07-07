import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/_shared/tracks/album_picture.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';

class SuggestionItem extends StatefulWidget {
  Suggestion suggestion;

  SuggestionItem({this.suggestion});

  @override
  _SuggestionItemState createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<SuggestionItem> {
  Track track;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    var suggestion = widget.suggestion;

    String elapsed = timeago.format(suggestion.date, locale: 'en_short');

    return FutureBuilder(
      future: state.api.tracks.get(suggestion.trackid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Track track = snapshot.data;
          return ListTile(
            leading: AlbumPicture(
              track: track,
              size: 50.0,
            ),
            title: Text(track.name),
            subtitle: Text('${track.artists[0].name}\n${track.album.name}'),
            isThreeLine: true,
            onTap: () async {
              // TODO: Open in Spotify
            },
          );
        } else {
          Text("Nothing!");
        }
      },
    );
  }
}
