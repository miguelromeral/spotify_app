import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/searcher.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:rxdart/subjects.dart';

class TrackListBloc extends Bloc<TrackBlocEvent, List<Track>>
    implements Searcher<Track> {
  List<Track> initialList;
  List<Track> originalList = new List();
  final _filteredData = BehaviorSubject<List<Track>>();
  Order _order = Order.byDefault;

  TrackListBloc(List<Track> list) {
    initialList = list;
    //originalList = list;
    copyList(list);
    _filteredData.add(initialList);
  }

  Future copyList(List<Track> list) async {
    if (list != null) {
      originalList.clear();
      for (var t in list) {
        originalList.add(t);
      }
    }
  }

  Stream<List<Track>> get filteredData => _filteredData.stream;

  @override
  get onDataFiltered => _filteredData.add;
  //get onDataFiltered => () => List<String>();
  //Function(List<String> p1, String p2) get onDataFiltered => (list) => _filteredData.add(list);

  @override
  List<Track> get data => initialList;

  @override
  List<Track> get initialState => List();

  @override
  Stream<List<Track>> mapEventToState(TrackBlocEvent event) async* {
    if (event is OrderTrackName) {
      /*_order = _order == Order.name ? Order.nameReverse : Order.name;
      initialList = _setOrder(initialList);
      _filteredData.add(initialList);*/
      await _choiceAction(Order.name);
      yield initialList;
    } else if (event is OrderTrackArtist) {
      await _choiceAction(Order.artist);
      yield initialList;
    } else if (event is OrderTrackAlbum) {
      await _choiceAction(Order.album);
      yield initialList;
    } else if (event is OrderTrackDefault) {
      await _choiceAction(Order.byDefault);
      yield initialList;
    }
  }

  Future _choiceAction(Order choice) async {
    if (choice == Order.name) {
      _order = _order == Order.name ? Order.nameReverse : Order.name;
    } else if (choice == Order.artist) {
      _order = _order == Order.artist ? Order.artistReverse : Order.artist;
    } else if (choice == Order.album) {
      _order = _order == Order.album ? Order.albumReverse : Order.album;
    } else if (choice == Order.byDefault) {
      _order =
          _order == Order.byDefault ? Order.byDefaultReverse : Order.byDefault;
    }
    //list = _setOrder(list);

    initialList = _setOrder(initialList);
    _filteredData.add(initialList);
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
      case Order.byDefault:
        return originalList;
      case Order.byDefaultReverse:
        return originalList.reversed.toList();
      default:
        return list;
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
  byDefaultReverse,
  playlistName,
  playlistNameReverse,
}

class ConstantsOrderOptions {
  static const String TrackName = 'By Track Name';
  static const String Artist = 'By Artist';
  static const String Album = 'By Album';
  static const String ByDefault = 'By Default';

  static const String PlaylistName = 'By Playlist Name';

  static const List<String> choices = <String>[
    TrackName,
    Artist,
    Album,
    ByDefault,
  ];

  static const List<String> choicesPL = [
    PlaylistName,
    ByDefault,
  ];
}
