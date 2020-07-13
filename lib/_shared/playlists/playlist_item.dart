import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/playlists/playlist_image.dart';
import 'package:spotify_app/_shared/popup/popup_item_base.dart';
import 'package:spotify_app/_shared/popup/popup_item_open_playlist.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/playlists/playlist_tracks_screen.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';

import '../custom_listtile.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    Key key,
    @required this.playlist,
  }) : super(key: key);

  final PlaylistSimple playlist;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            try {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaylistTrackScreen(api: state.api, playlist: playlist),
                ),
              );
            } catch (err) {
              print('Error when navigating from playlist: $err');
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Couldn't open the playlist.")));
            }
          },
          child: Container(
            color: colorBackground,
            child: CustomListTile(
              key: Key(playlist.id),
              leadingIcon: Container(
                width: 60.0,
                height: 60.0,
                child: PlaylistImage(
                  playlist: playlist,
                  size: 25.0,
                ),
              ),
              content: [
                Text(playlist.name, style: styleFeedTitle),
                Text('ID: ${playlist.id}', style: styleFeedTrack),
              ],
              menuItems: _getActions(),
            ),
          ),
        );
      },
    );
  }

  List<PopupMenuItem<PopupItemBase>> _getActions() {
    return [
      PopupItemOpenPlaylist(playlist: playlist).create(),
      //PopupItemUpdateSuggestion(track: widget.track).create(),
    ];
  }
}
