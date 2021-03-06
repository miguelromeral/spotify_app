import 'package:ShareTheMusic/models/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/searcher.dart';
import 'package:spotify/spotify.dart';
import 'package:rxdart/subjects.dart';

/// Bloc that manages the filtering of a list of tracks
class TrackListBloc extends Bloc<TrackBlocEvent, List<Track>>
    implements Searcher<Track> {
  /// Initial list, without any filter
  List<Track> initialList;

  /// Initial list with the default order, in case the user needs it
  List<Track> originalList = new List();

  /// Allows us to filter the initial list
  final _filteredData = BehaviorSubject<List<Track>>();

  /// Sort choice set to display the list of tracks
  Order _order = Order.byDefault;

  TrackListBloc(List<Track> list) {
    initialList = list;
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

  /// Stream that gives us the filtered list
  Stream<List<Track>> get filteredData => _filteredData.stream;

  /// Method of filtering the list
  @override
  get onDataFiltered => _filteredData.add;

  /// Original list
  @override
  List<Track> get data => initialList;

  /// First initial state, an empty list
  @override
  List<Track> get initialState => List();

  /// Sets a sorting method depending in the option selected by the user
  @override
  Stream<List<Track>> mapEventToState(TrackBlocEvent event) async* {
    if (event is OrderTrackName) {
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

  /// Sets the new sorting method and sorts the list
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
    initialList = _setOrder(initialList);
    _filteredData.add(initialList);
  }

  /// Sorts the list in function of the sorting method
  List<Track> _setOrder(List<Track> list) {
    switch (_order) {
      case Order.name:
        list.sort((a, b) => orderName(a, b));
        break;
      case Order.nameReverse:
        list.sort((a, b) => orderName(b, a));
        break;
      case Order.artist:
        list.sort((a, b) => orderArtistName(a, b));
        break;
      case Order.artistReverse:
        list.sort((a, b) => orderArtistName(b, a));
        break;
      case Order.album:
        list.sort((a, b) => orderAlbumName(a, b));
        break;
      case Order.albumReverse:
        list.sort((a, b) => orderAlbumName(b, a));
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
