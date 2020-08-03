import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/playlists/playlist_image.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_playlist.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/playlists/playlist_tracks_screen.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import '../custom_listtile.dart';

/// Playlist item in lists
class PlaylistItem extends StatelessWidget {
  /// Playlist to show
  final PlaylistSimple playlist;

  const PlaylistItem({
    Key key,
    @required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, MyApi>(
      builder: (context, api) => BlocBuilder<SpotifyBloc, SpotifyService>(
        builder: (context, state) {
          // When tapped, go to navigate its tracks
          return GestureDetector(
            onTap: () async {
              try {
                navigate(context,
                    PlaylistTrackScreen(api: api.get(), playlist: playlist));
              } catch (err) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Couldn't open the playlist.")));
              }
            },
            child: _buildTile(),
          );
        },
      ),
    );
  }

  Container _buildTile() {
    // Set a full container to allow the gesture detector listen to any tap throughout the tile.
    // otherwise, it only be possible to be tapped in the texts.
    return Container(
      color: Colors.transparent,
      child: CustomListTile(
        key: Key(playlist.id),
        // Playlist Image
        leadingIcon: Container(
          width: 60.0,
          height: 60.0,
          child: Hero(
            tag: playlist.id,
            child: PlaylistImage(
              playlist: playlist,
            ),
          ),
        ),
        content: [
          // Playlist name
          Text('${(playlist.collaborative ? '🔘 ' : '')}${playlist.name}',
              style: styleFeedTitle),
          SizedBox(
            height: 4.0,
          ),
          // Playlist owner
          Text('by ${playlist.owner.displayName}', style: styleFeedTrack),
          SizedBox(
            height: 4.0,
          ),
          // Public or private
          Text(playlist.public ? 'Public' : '🔒 Private',
              style: styleFeedTrack),
        ],
        menuItems: _getActions(),
      ),
    );
  }

  List<PopupMenuItem<PopupItemBase>> _getActions() {
    return [
      PopupItemOpenPlaylist(playlist: playlist).create(),
    ];
  }
}
