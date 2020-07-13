import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/custom_listtile.dart';
import 'package:spotify_app/_shared/playlists/playlist_image.dart';
import 'package:spotify_app/_shared/playlists/playlists_screen.dart';
import 'package:spotify_app/_shared/screens/loading_screen.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/_shared/tracks/track_list.dart';
import 'package:spotify_app/_shared/tracks/track_list_screen.dart';
import 'package:spotify_app/screens/playlists/playlist_tracks_screen.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

import '../styles.dart';

class MyPlaylistsScreen extends StatefulWidget {
  @override
  _MyPlaylistsScreenState createState() => _MyPlaylistsScreenState();
}

class _MyPlaylistsScreenState extends State<MyPlaylistsScreen> {
  SpotifyBloc _bloc;

  Future<void> _getData() async {
    print("pulling to refresh in playslist!");
    if (_bloc != null) {
      _bloc.add(UpdatePlaylists());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
      _getData();
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return StreamBuilder(
        stream: state.playlists,
        builder: (context, snp) {
          if (snp.hasData) {
            List<PlaylistSimple> liked = snp.data;
            return NotificationListener<RefreshListNotification>(
              onNotification: (notification) {
                _getData();
                return true;
              },
              child: PlaylistsScreen(
                list: liked,
                title: 'My Playlists',
              ),
            );
          } else {
            BlocProvider.of<SpotifyBloc>(context).add(UpdateSaved());
            return Scaffold(
              appBar: AppBar(
                title: Text('My Playlists'),
                centerTitle: true,
              ),
              body: LoadingScreen(),
            );
          }
        },
      );
    });
  }
}
