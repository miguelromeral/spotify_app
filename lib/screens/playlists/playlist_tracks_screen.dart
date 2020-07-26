import 'dart:async';

import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/_shared/playlists/playlist_image.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
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

import '../settings_screen.dart';

class PlaylistTrackScreen extends StatefulWidget {
  final SpotifyApi api;
  final PlaylistSimple playlist;

  PlaylistTrackScreen({this.api, this.playlist});

  @override
  _PlaylistTrackScreenState createState() => _PlaylistTrackScreenState();
}

class _PlaylistTrackScreenState extends State<PlaylistTrackScreen> {
  List<Track> tracks;

  Future<void> _getData() async {
    var expand = (await widget.api.playlists
            .getTracksByPlaylistId(widget.playlist.id)
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

  Widget _buildBody(BuildContext) {
    if (tracks == null || tracks.isEmpty) {
      return TrackListScreen(
        list: List(),
        loading: tracks == null,
        title: widget.playlist.name,
        widget: _createWidgetHeader(),
      );
    } else {
      return TrackListScreen(
        key: Key(tracks.length.toString()),
        list: filterLocalFiles(tracks),
        title: widget.playlist.name,
        widget: _createWidgetHeader(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<RefreshListNotification>(
        onNotification: (notification) {
          _getData();
          return true;
        },
        child: FancyBackgroundApp(
          child: _buildBody(context),
        ));
  }

  Widget _createWidgetHeader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Hero(
            tag: widget.playlist.id,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: PlaylistImage(
                playlist: widget.playlist,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Track> filterLocalFiles(List<Track> original) {
    if (Settings.getValue<bool>(settings_track_hide_local, false)) {
      return original.where((element) => element.id != null).toList();
    } else {
      return original;
    }
  }
}
