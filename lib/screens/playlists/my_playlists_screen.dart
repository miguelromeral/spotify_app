import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/playlists_bloc.dart';
import 'package:ShareTheMusic/models/playlists_data.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
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
  Future<void> _getData(BuildContext context, MyApi api) async {
    BlocProvider.of<PlaylistsBloc>(context)
        .add(UpdatePlaylistsEvent(newOne: await api.getMyPlaylists()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistsBloc, PlaylistsData>(
      builder: (context, data) =>
          BlocBuilder<ApiBloc, MyApi>(builder: (context, api) {
        return StreamBuilder(
          stream: data.playlists,
          builder: (context, snp) {
            if (snp.hasData) {
              return _buildBody(snp.data, api);
            } else if (data.last.isNotEmpty) {
              return _buildBody(data.last, api);
            } else {
              _getData(context, api);
              return LoadingScreen(
                title: 'Loading Your Playlists...',
                safeArea: true,
              );
            }
          },
        );
      }),
    );
  }

  Widget _buildBody(List<PlaylistSimple> liked, MyApi api) {
    if (liked.isNotEmpty) {
      return NotificationListener<RefreshListNotification>(
        onNotification: (notification) {
          _getData(context, api);
          return true;
        },
        child: PlaylistsScreen(
          key: Key(liked.hashCode.toString()),
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
            "We couldn't find any playlists in your library.",
            "Please, try again later."
          ],
        ),
      );
    }
  }
}
