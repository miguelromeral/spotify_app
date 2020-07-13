import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/screens/loading_screen.dart';
import 'package:spotify_app/_shared/tracks/track_item.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/blocs/track_list_bloc.dart';
import 'package:spotify_app/_shared/tracks/track_list_screen.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/_shared/tracks/track_list.dart';
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
            List<Track> liked = snp.data;
            return NotificationListener<RefreshListNotification>(
              onNotification: (notification) {
                _getData();
                return true;
              },
              child: TrackListScreen(
                list: liked,
                title: 'My Saved Songs',
              ),
            );
          } else {
            BlocProvider.of<SpotifyBloc>(context).add(UpdateSaved());
            return LoadingScreen();
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
