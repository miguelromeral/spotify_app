import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/screens/library/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class SavedTracksScreen extends StatefulWidget {
  @override
  _SavedTracksScreenState createState() => _SavedTracksScreenState();
}

class _SavedTracksScreenState extends State<SavedTracksScreen> {
  SpotifyBloc _bloc;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return StreamBuilder(
        stream: state.saved,
        builder: (context, snp) {
          if (snp.hasData) {
            var liked = snp.data;
            return Scaffold(
              /*floatingActionButton: FloatingActionButton.extended(
                key: GlobalKey(),
                onPressed: () async {
                  _getData();
                },
                icon: Icon(Icons.refresh),
                label: Text("Refresh"),
              ),*/
              body: Center(
                child: NotificationListener<RefreshListNotification>(
                  onNotification: (notification) {
                    _getData();
                    return true;
                  },
                  child: ListSongs(
                    key: Key(liked.length.toString()),
                    tracks: liked,
                    title: 'My Saved Songs',
                    refresh: true,
                  ),
                  //),
                ),
              ),
            );
          } else {
            BlocProvider.of<SpotifyBloc>(context).add(UpdateSaved());
            return CircularProgressIndicator();
          }
        },
      );
    });
  }

  Future<void> _getData() async {
    if (_bloc != null) {
      _bloc.add(UpdateSaved());
    }
  }
}
