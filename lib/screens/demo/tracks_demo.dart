import 'dart:async';

import 'package:ShareTheMusic/_shared/playlists/playlist_image.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/saved_tracks_bloc.dart';
import 'package:ShareTheMusic/models/saved_tracks_data.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list_screen.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class SavedTracksDemo extends StatefulWidget {
  @override
  _SavedTracksDemoState createState() => _SavedTracksDemoState();
}

class _SavedTracksDemoState extends State<SavedTracksDemo> {

  List<Track> _tracks;
  PlaylistSimple _playlist;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) => BlocBuilder<SavedTracksBloc, SavedTracksData>(
        builder: (context, data) =>
            BlocBuilder<ApiBloc, MyApi>(builder: (context, api) {
          return buildBody(context, api, state);
        }),
      ),
    );
  }

  Widget buildBody(BuildContext context, MyApi api, SpotifyService state) {
    return FutureBuilder(
        future: _getData(context, api),
        builder: (context, snp) {
          if (snp.hasData) {
            return NotificationListener<RefreshListNotification>(
              onNotification: (notification) {
                _getData(context, api);
                return true;
              },
              child: _create(context, api, state),
            );
          } else {
            return LoadingScreen();
          }
        });
  }

  Widget _create(BuildContext context, MyApi api, SpotifyService state) {
    List<Track> l = _tracks;
    bool loading = false;
    if (_tracks == null) {
      l = List<Track>();
      loading = true;
    }
    return TrackListScreen(
      widget: _createWidgetHeader(state),
      list: l,
      loading: loading,
      title: 'My Saved Songs (DEMO)',
    );
  }

  Widget _createWidgetHeader(SpotifyService state) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 100.0,
            width: 100.0,
            child: PlaylistImage(
              playlist: _playlist,
              size: 25.0,
            ),
          ),
          SizedBox(height: 20,),
          Center(child: Text("Let's image your favorite songs are all of these:")),
        ],
      ),
    );
  }

  Future<bool> _getData(BuildContext context, MyApi api) async {
    var id = '37i9dQZEVXbMDoHDwVN2tF';
    var expand = (await api.getTracksByPlaylist(id));
    var pl = (await api.getPlaylist(id));
    setState(() {
      _tracks = expand;
      _playlist = pl;
    });
    return true;
  }
}
