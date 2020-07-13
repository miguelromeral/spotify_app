import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/searcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/services/firestore_db.dart';
import 'package:spotify_app/services/firebase_auth.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:spotify_app/services/password_generator.dart';
import 'package:rxdart/subjects.dart';

class TrackListBloc extends Bloc<TrackBlocEvent, List<Track>>
    implements Searcher<Track> {
  List<Track> initialList; // = ['one','two','three','four'];
  final _filteredData = BehaviorSubject<List<Track>>();
  Order _order = Order.byDefault;

  TrackListBloc(List<Track> list) {
    initialList = list;
    _filteredData.add(initialList);
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
    }else if(event is OrderTrackArtist) {
      await _choiceAction(Order.artist);
      yield initialList;
    }else if(event is OrderTrackAlbum){
      await _choiceAction(Order.album);
      yield initialList;
    }

    /* else if (event is UpdateFeed) {
      state.updateFeed(await _updateFeed(state));
      yield state;
    } else if (event is UpdateMySuggestion) {
      state.updateMySuggestion(await _updateMySuggestion(state));
      yield state;
    } else if (event is UpdateSaved) {
      state.updateSaved(await _updateSaved(state));
      yield state;
    } else if (event is UpdatePlaylists) {
      state.updatePlaylists(await _updatePlaylists(state));
      yield state;
    } else if (event is LogoutEvent) {
      _clearCredentials();
      //state.dispose();
      //state.logout();
      SpotifyService newone = SpotifyService();
      yield newone;
    } else {
      throw Exception('oops');
    }*/
  }

  Future _choiceAction(Order choice) async {
    if (choice == Order.name) {
      _order = _order == Order.name ? Order.nameReverse : Order.name;
    } else if (choice == Order.artist) {
      _order = _order == Order.artist ? Order.artistReverse : Order.artist;
    } else if (choice == Order.album) {
      _order = _order == Order.album ? Order.albumReverse : Order.album;
    }
    /* else {
        _order = Order.byDefault;
      }*/
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
      default:
        return initialList;
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

class ConstantsOrderOptions {
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
