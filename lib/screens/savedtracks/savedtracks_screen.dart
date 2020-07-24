import 'dart:async';

import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/saved_tracks_bloc.dart';
import 'package:ShareTheMusic/models/saved_tracks_data.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
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

class SavedTracksScreen extends StatefulWidget {
  @override
  _SavedTracksScreenState createState() => _SavedTracksScreenState();
}

class _SavedTracksScreenState extends State<SavedTracksScreen> {
  SpotifyBloc _bloc;
  SpotifyApi _api;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null || _api == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
      _api = BlocProvider.of<ApiBloc>(context).state.get();
    }

    return BlocBuilder<SavedTracksBloc, SavedTracksData>(
      builder: (context, data) =>
          BlocBuilder<ApiBloc, MyApi>(builder: (context, api) {
        return StreamBuilder(
          stream: data.saved,
          builder: (context, snp) {
            if (snp.hasData) {
              return buildBody(context, api, snp.data);
            } else if (data.last.length != 0) {
              return buildBody(context, api, data.last);
            } else {
              _getData(context, api);
              return LoadingScreen(title: 'Loading Your Saved Tracks', safeArea: true,);
            }
          },
        );
      }),
    );
  }

  Widget buildBody(BuildContext context, MyApi api, List<Track> liked) {
    return NotificationListener<RefreshListNotification>(
      onNotification: (notification) {
        _getData(context, api);
        return true;
      },
      child: TrackListScreen(
        widget: Text("Saved Tracks"),
        key: Key(liked.hashCode.toString()),
        list: liked,
        title: 'My Saved Songs',
      ),
    );
  }

  Future<void> _getData(BuildContext context, MyApi api) async {
    /*if (_bloc != null && _api != null) {

      //_bloc.add(UpdateSaved(api: _api));
      BlocProvider.of<SavedTracksBloc>(context).add(UpdateSavedTracksEvent(newOne: await api.getMySavedTracks()));
    }*/
    BlocProvider.of<SavedTracksBloc>(context)
        .add(UpdateSavedTracksEvent(newOne: await api.getMySavedTracks()));
  }
}
