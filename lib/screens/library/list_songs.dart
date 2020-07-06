import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/_shared/album_picture.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';

class ListSongs extends StatefulWidget {
  List<Track> tracks;

  ListSongs({Key key, this.tracks}) : super(key: key);

  @override
  _ListSongsState createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');
  BuildContext _context;
  DateTime lastUpdate;

  List<Track> filteredTracks = new List();

  _ListSongsState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredTracks = widget.tracks;
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
        filteredTracks = widget.tracks;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      String text = _searchText.toLowerCase();
      List<Track> tempList = new List();
      for (Track t in filteredTracks) {
        bool hit = false;
        if (t.name.toLowerCase().contains(text)) {
          hit = true;
        }
        if (!hit) {
          for (var a in t.artists) {
            if (a.name.toLowerCase().contains(text)) {
              hit = true;
              break;
            }
          }
        }
        if (hit) {
          tempList.add(t);
        }
      }
      filteredTracks = tempList;
    }
    return RefreshIndicator(
      onRefresh: _getData,
          child: ListView.builder(
          itemCount: widget.tracks == null ? 0 : filteredTracks.length,
          itemBuilder: (_, index) {
            Track saved = filteredTracks[index];
            return ListTile(
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
            );
          }),
    );
  }


  Future<void> _getData() async {
    print("pulling to refresh in list_songs!");
    if (_context != null) {

      RefreshListNotification().dispatch(_context);
      //await Future.delayed(Duration(seconds: 5));
      /*setState(() {
        lastUpdate = DateTime.now();
      });*/
    }
  }


  @override
  void initState() {
    filteredTracks = widget.tracks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;
    
    if(_context == null){
      _context = context;
    }

    return Flexible(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: _appBarTitle,
            leading: new IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ),
          body: _buildList()),
    );
  }
}
