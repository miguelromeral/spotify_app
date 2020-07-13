import 'package:dio/dio.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/custom_listtile.dart';
import 'package:spotify_app/_shared/playlists/playlist_image.dart';
import 'package:spotify_app/_shared/playlists/playlist_item.dart';
import 'package:spotify_app/_shared/tracks/track_item.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/playlists/playlist_tracks_screen.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class PlaylistList extends StatefulWidget {
  final List<PlaylistSimple> tracks;
  final String title;
  final bool refresh;

  PlaylistList({Key key, this.tracks, this.title, this.refresh})
      : super(key: key);

  @override
  _PlaylistListState createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  final ScrollController _controller = ScrollController();

  List<PlaylistSimple> list;

  BuildContext _context;

  Future<void> _getData() async {
    print("pulling to refresh in list_songs!");
    if (_context != null) {
      RefreshListNotification().dispatch(_context);
      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    list = widget.tracks;
    super.initState();
  }

  Widget _buildList() {
    if (widget.refresh) {
      return RefreshIndicator(
        onRefresh: _getData,
        child: _listBuilder(),
      );
    } else {
      return _listBuilder();
    }
  }

  Widget _listBuilder() {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return ListView.separated(
            controller: _controller,
            key: GlobalKey(),
            separatorBuilder: (context, index) => Divider(
                  color: colorSeprator,
                ),
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (_, index) {
              return PlaylistItem(playlist: list[index]);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }

    return _buildList();
  }
}

