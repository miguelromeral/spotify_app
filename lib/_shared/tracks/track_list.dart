import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/_shared/tracks/track_item.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/notifications.dart';

class TrackList extends StatefulWidget {
  List<Track> tracks;
  String title;
  bool refresh;

  TrackList({Key key, this.tracks, this.title, this.refresh}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle; // = new Text('${widget.title}');
  BuildContext _context;
  DateTime lastUpdate;

  Order _order;

  List<Track> initialList = new List();
  List<Track> filteredTracks = new List();

  _TrackListState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredTracks = initialList;
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
        this._appBarTitle = new Text(widget.title);
        filteredTracks = initialList;
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

    if (widget.refresh) {
      return RefreshIndicator(
        onRefresh: _getData,
        child: _listBuilder(),
      );
    } else {
      return _listBuilder();
    }
  }

  Widget _listBuilder() {
    return ListView.separated(
        key: GlobalKey(),
        separatorBuilder: (context, index) => Divider(
              color: colorSeprator,
            ),
        itemCount: filteredTracks == null ? 0 : filteredTracks.length,
        itemBuilder: (_, index) {
          return TrackItem(track: filteredTracks[index]);
        });
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
    initialList = widget.tracks;
    filteredTracks = widget.tracks;
    _appBarTitle = new Text('${widget.title}');
    _order = Order.byDefault;
    super.initState();
  }

  void choiceAction(String choice) {
    setState(() {
      if (choice == Constants.TrackName) {
        _order = _order == Order.name ? Order.nameReverse : Order.name;
      } else if (choice == Constants.Artist) {
        _order = _order == Order.artist ? Order.artistReverse : Order.artist;
      } else if (choice == Constants.Album) {
        _order = _order == Order.album ? Order.albumReverse : Order.album;
      }/* else {
        _order = Order.byDefault;
      }*/
      initialList = _setOrder(initialList);
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    if (_context == null) {
      _context = context;
    }

    return Flexible(
      child: Scaffold(
          appBar: AppBar(centerTitle: true, title: _appBarTitle, actions: [
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
            PopupMenuButton<String>(
              onSelected: choiceAction,
              child: Icon(Icons.sort),
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
          body: _buildList()),
    );
  }

  List<Track> _setOrder(List<Track> list) {
    switch (_order) {
      case Order.name:
        list.sort((a, b) => _orderName(a, b));
        break;
      case Order.nameReverse:
        list.sort((a, b) => _orderName(b, a));
        break;
      case Order.artist:
        list.sort((a, b) => _orderArtistName(a, b));
        break;
      case Order.artistReverse:
        list.sort((a, b) => _orderArtistName(b, a));
        break;
      case Order.album:
        list.sort((a, b) => _orderAlbumName(a, b));
        break;
      case Order.albumReverse:
        list.sort((a, b) => _orderAlbumName(b, a));
        break;
      default:
        return widget.tracks;
    }
    return list;
  }
}

int _orderName(Track a, Track b) => a.name.compareTo(b.name);
int _orderArtistName(Track a, Track b) =>
    a.artists[0].name.compareTo(b.artists[0].name);
int _orderAlbumName(Track a, Track b) => a.album.name.compareTo(b.album.name);

enum Order {
  name,
  nameReverse,
  artist,
  artistReverse,
  album,
  albumReverse,
  byDefault,
}

class Constants {
  static const String TrackName = 'By Track Name';
  static const String Artist = 'By Artist';
  static const String Album = 'By Album';
 // static const String ByDefault = 'By Default';

  static const List<String> choices = <String>[
    TrackName,
    Artist,
    Album,
 //   ByDefault,
  ];
}
