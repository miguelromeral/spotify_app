import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/_shared/playlists/playlist_image.dart';
import 'package:spotify_app/screens/library/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    Key key,
    @required this.playlist,
    @required this.context,
  }) : super(key: key);

  final PlaylistSimple playlist;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return ListTile(
          leading: PlaylistImage(
            playlist: playlist,
          ),
          title: Text(playlist.name),
          subtitle: Text('ID: ${playlist.id}'),
          onLongPress: () async {
            if (await canLaunch(playlist.uri)) {
              launch(playlist.uri);
            }
          },
          onTap: () async {
            try {
              var expand = (await state.api.playlists
                      .getTracksByPlaylistId(playlist.id)
                      .all())
                  .toList();

              var list = List<Track>();
              for (var t in expand) {
                list.add(t);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListSongs(
                          key: Key('${playlist.id}_${list.length}'),
                          tracks: list,
                          title: playlist.name,
                          refresh: false,
                        )),
              );
            } catch (err) {
              print(err);
            }
          },
        );
      },
    );
  }
}
