import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/playlists_bloc.dart';
import 'package:ShareTheMusic/models/playlists_data.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/playlists/playlists_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class MyPlaylistsScreen extends StatefulWidget {
  @override
  _MyPlaylistsScreenState createState() => _MyPlaylistsScreenState();
}

class _MyPlaylistsScreenState extends State<MyPlaylistsScreen> {
  Future<void> _getData(BuildContext context, MyApi api) async {
    BlocProvider.of<PlaylistsBloc>(context)
        .add(UpdatePlaylistsEvent(newOne: await api.getMyPlaylists()));
  }

  List<PlaylistSimple> _list = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return BlocBuilder<PlaylistsBloc, PlaylistsData>(
      builder: (context, data) =>
          BlocBuilder<ApiBloc, MyApi>(builder: (context, api) {
        return StreamBuilder(
          stream: data.playlists,
          builder: (context, snp) {
            if (snp.hasData) {
              return buildBody(context, api, snp.data, state);
            } else if (data.last.isNotEmpty) {
              return buildBody(context, api, data.last, state);
            } else {
              _getData(context, api);
              return buildBody(context, api, null, state);
            }
          },
        );
      }),
    );
  }

  Widget buildBody(BuildContext context, MyApi api, List<PlaylistSimple> liked,
      SpotifyService state) {
    return NotificationListener<RefreshListNotification>(
      onNotification: (notification) {
        _getData(context, api);
        return true;
      },
      child: _create(context, api, liked, state),
    );
  }

  Widget _create(BuildContext context, MyApi api, List<PlaylistSimple> liked,
      SpotifyService state) {
    List<PlaylistSimple> l = liked;
    bool loading = false;
    if (liked == null) {
      l = List<PlaylistSimple>();
      loading = true;
    }

    return PlaylistsScreen(
      key: Key(liked.hashCode.toString()),
      list: l,
      title: 'My Playlists',
      header: _createWidgetHeader(state, _list),
      loading: loading,
    );
  }

  Widget _createWidgetHeader(SpotifyService state, List<PlaylistSimple> list) {
    return ProfilePicture(
      size: 100.0,
      user: state.myUser,
    );
  }
}
