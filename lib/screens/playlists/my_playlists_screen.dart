import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/custom_listtile.dart';
import 'package:ShareTheMusic/_shared/playlists/playlist_image.dart';
import 'package:ShareTheMusic/_shared/playlists/playlists_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list_screen.dart';
import 'package:ShareTheMusic/screens/playlists/playlist_tracks_screen.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import '../styles.dart';

class MyPlaylistsScreen extends StatefulWidget {
  @override
  _MyPlaylistsScreenState createState() => _MyPlaylistsScreenState();
}

class _MyPlaylistsScreenState extends State<MyPlaylistsScreen> {
  SpotifyBloc _bloc;
  SpotifyApi _api;

  Future<void> _getData() async {
    print("pulling to refresh in playslist!");
    if (_bloc != null && _api != null) {
      _bloc.add(UpdatePlaylists(api: _api));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null || _api == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
      _api = BlocProvider.of<ApiBloc>(context).state.get();
      //_getData();
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return StreamBuilder(
        stream: state.playlists,
        builder: (context, snp) {
          if (snp.hasData) {
            List<PlaylistSimple> liked = snp.data;
            if (liked.isNotEmpty) {
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
              return Scaffold(
                appBar: AppBar(
                  title: Text('My Playlists'),
                  centerTitle: true,
                ),
                body: ErrorScreen(
                  title: "There's no playlist we could find",
                  stringBelow: [
                    "We couldn't find any playlists own by you.",
                    "Please, try again later."
                  ],
                ),
              );
            }
          } else {
            _getData();
            return Scaffold(
              appBar: AppBar(
                title: Text('My Playlists'),
                centerTitle: true,
              ),
              body: LoadingScreen(
                title: 'Loading Your Playlists...',
              ),
            );
          }
        },
      );
    });
  }
}
