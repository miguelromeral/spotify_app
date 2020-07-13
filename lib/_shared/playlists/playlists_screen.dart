import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/playlists/playlist_list.dart';
import 'package:spotify_app/_shared/tracks/track_item.dart';
import 'package:spotify_app/_shared/tracks/track_list.dart';
import 'package:spotify_app/blocs/playlist_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/blocs/track_list_bloc.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/notifications.dart';

class PlaylistsScreen extends StatefulWidget {
  final Key key;
  final String title;
  final List<PlaylistSimple> list;

  PlaylistsScreen({this.key, this.list, this.title});

  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  PlaylistBloc tlb;

  @override
  void initState() {
    tlb = PlaylistBloc(widget.list);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar<PlaylistSimple>(
        title: Text(widget.title),
        searcher: tlb,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        searchElementsColor: Colors.white,
        searchBackgroundColor: colorAccent,
        filter: (PlaylistSimple str, String query) =>
            Filters.contains(str.name, query),
      ),
      body: Center(
        child: StreamBuilder<List<PlaylistSimple>>(
          stream: tlb.filteredData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final list = snapshot.data;
            return PlaylistList(
              key: Key(list.hashCode.toString()),
              tracks: list,
              title: widget.title,
              refresh: true,
            );
          },
        ),
      ),
    );
  }
}
