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

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    Key key,
    @required this.playlist,
  }) : super(key: key);

  final PlaylistSimple playlist;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, MyApi>(
      builder: (context, api) => BlocBuilder<SpotifyBloc, SpotifyService>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () async {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlaylistTrackScreen(api: api.get(), playlist: playlist),
                  ),
                );
              } catch (err) {
                print('Error when navigating from playlist: $err');
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
    return Container(
      color: Colors.transparent,
      child: CustomListTile(
        key: Key(playlist.id),
        leadingIcon: Container(
          width: 60.0,
          height: 60.0,
          child: Hero(
            tag: playlist.id,
            child: PlaylistImage(
              playlist: playlist,
              size: 25.0,
            ),
          ),
        ),
        content: [
          Text('${(playlist.collaborative ? '🔘 ' : '')}${playlist.name}',
              style: styleFeedTitle),
          SizedBox(
            height: 4.0,
          ),
          Text('by ${playlist.owner.displayName}', style: styleFeedTrack),
          SizedBox(
            height: 4.0,
          ),
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
      //PopupItemUpdateSuggestion(track: widget.track).create(),
    ];
  }
}
