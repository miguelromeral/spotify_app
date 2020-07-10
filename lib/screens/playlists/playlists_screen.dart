import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/custom_listtile.dart';
import 'package:spotify_app/_shared/playlists/playlist_image.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/_shared/tracks/track_list.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

import '../styles.dart';

class PlaylistsScreen extends StatefulWidget {
  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('My Playlists');
  BuildContext _context;

  List<PlaylistSimple> initialList = new List();
  List<PlaylistSimple> filteredList = new List();

  _PlaylistsScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredList = initialList;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('My Playlists');
        filteredList = initialList;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      String text = _searchText.toLowerCase();
      List<PlaylistSimple> tempList = new List();
      for (var t in filteredList) {
        if (t.name.toLowerCase().contains(text)) {
          tempList.add(t);
        }
      }
      filteredList = tempList;
    }
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return NotificationListener<RefreshListNotification>(
          onNotification: (notification) {
            print("Notification: $notification");
            _getData();
            return true;
          },
          child: RefreshIndicator(
            onRefresh: _getData,
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: colorSeprator,
                    ),
                itemCount: initialList == null ? 0 : filteredList.length,
                itemBuilder: (_, index) {
                  PlaylistSimple pl = filteredList[index];
                  return GestureDetector(
                    onLongPress: () async {
                      openUrl(pl.uri);
                    },
                    onTap: () async {
                      try {
                        var expand = (await state.api.playlists
                                .getTracksByPlaylistId(pl.id)
                                .all())
                            .toList();

                        var list = List<Track>();
                        for (var t in expand) {
                          list.add(t);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackList(
                                    key: Key('${pl.id}_${list.length}'),
                                    tracks: list,
                                    title: pl.name,
                                    refresh: false,
                                  )),
                        );
                      } catch (err) {
                        print(err);
                      }
                    },
                    child: Container(
                      color: colorBackground,
                      child: CustomListTile(
                        key: Key(pl.id),
                        leadingIcon: Container(
                          width: albumIconSize,
                          height: albumIconSize,
                          child: PlaylistImage(
                            playlist: pl,
                          ),
                        ),
                        content: [
                          Text(pl.name, style: styleFeedTitle),
                          Text('ID: ${pl.id}', style: styleFeedTrack),
                        ],
                      ),
                    ),
                  );
                  //return PlaylistItem(playlist: filteredList[index], context: context);
                }),
          ),
        );
      },
    );
  }

  Future<void> _getData() async {
    print("pulling to refresh in playslist!");
    if (_context != null && _bloc != null) {
      _bloc.add(UpdatePlaylists());

      _bloc.state.playlists.listen((event) {
        setState(() {
          initialList = event;
          filteredList = initialList;
        });
      });

      setState(() {
        filteredList = initialList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  SpotifyBloc _bloc;

  @override
  Widget build(BuildContext context) {
    if (_context == null || _bloc == null) {
      _context = context;
      _bloc = BlocProvider.of<SpotifyBloc>(context);
      _getData();
    }

    return Flexible(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: _appBarTitle,
            actions: [
              IconButton(
                icon: _searchIcon,
                onPressed: _searchPressed,
              ),
            ],
          ),
          body: _buildList()),
    );
  }
}
