import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/searcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/password_generator.dart';
import 'package:rxdart/subjects.dart';

class PlaylistBloc extends Bloc<TrackBlocEvent, List<PlaylistSimple>>
    implements Searcher<PlaylistSimple> {
  List<PlaylistSimple> initialList;
  List<PlaylistSimple> originalList = new List();
  final _filteredData = BehaviorSubject<List<PlaylistSimple>>();
  Order _order = Order.byDefault;

  PlaylistBloc(List<PlaylistSimple> list) {
    initialList = list;
    copyList(list);
    _filteredData.add(initialList);
  }

  Future copyList(List<PlaylistSimple> list) async {
    if (list != null) {
      originalList.clear();
      for (var t in list) {
        originalList.add(t);
      }
    }
  }

  Stream<List<PlaylistSimple>> get filteredData => _filteredData.stream;

  @override
  get onDataFiltered => _filteredData.add;

  @override
  List<PlaylistSimple> get data => initialList;

  @override
  List<PlaylistSimple> get initialState => List();

  @override
  Stream<List<PlaylistSimple>> mapEventToState(TrackBlocEvent event) async* {
    if (event is OrderPlaylistName) {
      await _choiceAction(Order.playlistName);
      yield initialList;
    } else if (event is OrderTrackDefault) {
      await _choiceAction(Order.byDefault);
      yield initialList;
    }
  }

  Future _choiceAction(Order choice) async {
    if (choice == Order.playlistName) {
      _order = _order == Order.playlistName
          ? Order.playlistNameReverse
          : Order.playlistName;
    } else if (choice == Order.byDefault) {
      _order =
          _order == Order.byDefault ? Order.byDefaultReverse : Order.byDefault;
    }
    //list = _setOrder(list);

    initialList = _setOrder(initialList);
    _filteredData.add(initialList);
  }

  List<PlaylistSimple> _setOrder(List<PlaylistSimple> list) {
    switch (_order) {
      case Order.playlistName:
        list.sort((a, b) => _orderName(a, b));
        break;
      case Order.playlistNameReverse:
        list.sort((a, b) => _orderName(b, a));
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

  int _orderName(PlaylistSimple a, PlaylistSimple b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase());
}
