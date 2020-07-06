import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/_shared/album_picture.dart';
import 'package:spotify_app/screens/_shared/playlist_image.dart';
import 'package:spotify_app/screens/library/list_songs.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';

class PlaylistsScreen extends StatefulWidget {
  //PlaylistsScreen({Key key, this.tracks}) : super(key: key);

  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');
  BuildContext _context;
  DateTime lastUpdate;

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
        this._appBarTitle = new Text('Search Example');
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
    return NotificationListener<RefreshListNotification>(
      onNotification: (notification) {
        print("Notification: $notification");
        /*setState(() {
                  //_retrieve(state);
                  bloc.add(UpdateFeed());
                });*/
        _getData();
        return true;
      },
      child: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.builder(
            itemCount: initialList == null ? 0 : filteredList.length,
            itemBuilder: (_, index) {
              var saved = filteredList[index];
              /*return ListTile(
                leading: AlbumPicture(
                  track: saved,
                  size: 25.0,
                ),
                title: Text(saved.name),
                subtitle: Text(saved.artists[0].name),
                //trailing: icon,
                //isThreeLine: true,
                // Interactividad:
                onTap: () async {
                  /*
                    var spUser = await state.myUser;
                    state.db.updateUserData(spUser.id, saved.id);*/
                  //bloc.add(ShareTrackEvent(track: saved));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShareTrack(track: saved)),
                  );
                },
                //onLongPress: () => _pressCallback,
                //enabled: false,
                //selected: true,
              );*/
              return ListTile(
                leading: PlaylistImage(
                  playlist: saved,
                ),
                title: Text(saved.name),
                onTap: () async {
                  try {
                    var expand = (await _bloc.state.api.playlists
                            .getTracksByPlaylistId(saved.id)
                            .all())
                        .toList();

                    var list = List<Track>();
                    for (var t in expand) {
                      list.add(t);
                    }

                    // print(expand);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListSongs(
                                key: Key('${saved.id}_${list.length}'),
                                tracks: list,
                              )),
                    );
                  } catch (err) {
                    print(err);
                  }
                },
              );
            }),
      ),
    );
  }

  Future<void> _getData() async {
    print("pulling to refresh in playslist!");
    if (_context != null && _bloc != null) {
      //RefreshListNotification().dispatch(_context);
      _bloc.add(UpdatePlaylists());
      setState(() {
        initialList = _bloc.state.playlists;
        filteredList = initialList;
      });
      //await Future.delayed(Duration(seconds: 5));
      /*setState(() {
        lastUpdate = DateTime.now();
      });*/
    }
  }

  @override
  void initState() {
    //_getData();
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

  /*
  @override
  Widget build(BuildContext context) {
    return Text("Playlists"); 
  }*/
}
