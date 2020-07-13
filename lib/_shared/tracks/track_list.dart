import 'package:dio/dio.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/tracks/track_item.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/notifications.dart';

class TrackList extends StatefulWidget {
  final List<Track> tracks;
  final String title;
  final bool refresh;

  TrackList({Key key, this.tracks, this.title, this.refresh}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {

  final ScrollController _controller = ScrollController();

  List<Track> list;

  BuildContext _context;

  Order _order;


  Widget _buildList() {
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
    return DraggableScrollbar.arrows(
      backgroundColor: colorAccent,
      labelTextBuilder: (offset) {
        final int currentItem = _controller.hasClients
            ? (_controller.offset /
                    _controller.position.maxScrollExtent *
                    (list == null ? 0 : list.length))
                .floor()
            : -1;

        return Text(
          _getScrollThumbText(currentItem),
          style: TextStyle(color: Colors.black),
        );

      },
      labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
      controller: _controller,
      child: ListView.separated(
          controller: _controller,
          key: GlobalKey(),
          separatorBuilder: (context, index) => Divider(
                color: colorSeprator,
              ),
          itemCount: list == null ? 0 : list.length,
          itemBuilder: (_, index) {
            return TrackItem(track: list[index]);
          }),
    );
  }

  String _getScrollThumbText(int currentItem) {
    if (currentItem != -1 && currentItem < list.length) {
      return _getTrackNameShort(currentItem);
    } else if (currentItem == list.length) {
      return _getTrackNameShort(currentItem - 1);
    } else {
      return "";
    }
  }

  String _getTrackNameShort(int currentItem) {
    var item = list[currentItem];
    var text = (item.name.length < 10
        ? item.name
        : "${item.name.substring(0, 10)}...");
    return text;
  }

  Future<void> _getData() async {
    print("pulling to refresh in list_songs!");
    if (_context != null) {
      RefreshListNotification().dispatch(_context);
      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    list = widget.tracks;
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
      }
      /* else {
        _order = Order.byDefault;
      }*/
      list = _setOrder(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }

    return  _buildList();
/*
    return Flexible(
      child: Scaffold(
          appBar: AppBar(centerTitle: true, title: _appBarTitle, actions: [
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
            /*PopupMenuButton<String>(
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
            ),*/
          ]),
          body: _buildList()),
    );*/
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

int _orderName(Track a, Track b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase());
int _orderArtistName(Track a, Track b) =>
    a.artists[0].name.toLowerCase().compareTo(b.artists[0].name.toLowerCase());
int _orderAlbumName(Track a, Track b) =>
    a.album.name.toLowerCase().compareTo(b.album.name.toLowerCase());

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
