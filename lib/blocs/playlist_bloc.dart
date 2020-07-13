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

class PlaylistBloc extends Bloc<TrackBlocEvent, List<PlaylistSimple>>
    implements Searcher<PlaylistSimple> {
  List<PlaylistSimple> initialList;
  final _filteredData = BehaviorSubject<List<PlaylistSimple>>();

  PlaylistBloc(List<PlaylistSimple> list) {
    initialList = list;
    _filteredData.add(initialList);
  }

  Stream<List<PlaylistSimple>> get filteredData => _filteredData.stream;

  @override
  get onDataFiltered => _filteredData.add;

  @override
  List<PlaylistSimple> get data => initialList;

  @override
  List<PlaylistSimple> get initialState => List();

  @override
  Stream<List<PlaylistSimple>> mapEventToState(TrackBlocEvent event) async* {}
}
