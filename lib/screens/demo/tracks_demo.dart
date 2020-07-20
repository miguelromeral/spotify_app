import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/tracks/track_item.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list_screen.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class SavedTracksDemo extends StatefulWidget {
  final SpotifyApi api;

  SavedTracksDemo({this.api,});

  @override
  _SavedTracksDemoState createState() => _SavedTracksDemoState();
}

class _SavedTracksDemoState extends State<SavedTracksDemo> {
  List<Track> tracks;

  Future<void> _getData() async {
    var expand = (await widget.api.playlists
            // TOP 50 Global
            .getTracksByPlaylistId('37i9dQZEVXbMDoHDwVN2tF')
            .all())
        .toList();

    setState(() {
      tracks = expand;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tracks == null || tracks.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('My DEMO Tracks'),
          ),
          body: LoadingScreen());
    } else {
      return NotificationListener<RefreshListNotification>(
        onNotification: (notification) {
          _getData();
          return true;
        },
        child: TrackListScreen(
          key: Key(tracks.length.toString()),
          list: tracks,
          title: 'My DEMO Tracks',
        ),
      );
    }
  }
}
