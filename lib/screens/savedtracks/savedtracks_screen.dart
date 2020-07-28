import 'dart:async';

import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/saved_tracks_bloc.dart';
import 'package:ShareTheMusic/models/saved_tracks_data.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list_screen.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class SavedTracksScreen extends StatefulWidget {
  @override
  _SavedTracksScreenState createState() => _SavedTracksScreenState();
}

class _SavedTracksScreenState extends State<SavedTracksScreen> {
  
  //SpotifyApi _api;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) => BlocBuilder<SavedTracksBloc, SavedTracksData>(
        builder: (context, data) =>
            BlocBuilder<ApiBloc, MyApi>(builder: (context, api) {
          return StreamBuilder(
            stream: data.saved,
            builder: (context, snp) {
              if (snp.hasData) {
                return buildBody(context, api, snp.data, state);
              } else if (data.last.length != 0) {
                return buildBody(context, api, data.last, state);
              } else {
                _getData(context, api);
                return buildBody(context, api, null, state);
              }
            },
          );
        }),
      ),
    );
  }

  Widget buildBody(BuildContext context, MyApi api, List<Track> liked,
      SpotifyService state) {
    return NotificationListener<RefreshListNotification>(
      onNotification: (notification) {
        _getData(context, api);
        return true;
      },
      child: _create(context, api, liked, state),
    );
  }

  Widget _create(BuildContext context, MyApi api, List<Track> liked,
      SpotifyService state) {
    List<Track> l = liked;
    bool loading = false;
    if (liked == null) {
      l = List<Track>();
      loading = true;
    }
    return TrackListScreen(
      widget: _createWidgetHeader(state),
      key: Key(liked.hashCode.toString()),
      list: l,
      loading: loading,
      title: 'My Saved Songs',
    );
  }

  Widget _createWidgetHeader(SpotifyService state) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          ProfilePicture(
            size: 100.0,
            user: state.myUser,
          ),
        ],
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
