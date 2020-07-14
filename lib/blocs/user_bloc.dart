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

class UserBloc extends Bloc<TrackBlocEvent, List<UserPublic>>
    implements Searcher<UserPublic> {
      
  List<UserPublic> initialList;

  final _filteredData = BehaviorSubject<List<UserPublic>>();

  UserBloc(List<UserPublic> list) {
    initialList = list;
    _filteredData.add(initialList);
  }

  Stream<List<UserPublic>> get filteredData => _filteredData.stream;

  @override
  get onDataFiltered => _filteredData.add;

  @override
  List<UserPublic> get data => initialList;

  @override
  List<UserPublic> get initialState => List();

  @override
  Stream<List<UserPublic>> mapEventToState(TrackBlocEvent event) async* {
    /*if (event is OrderTrackName) {
      await _choiceAction(Order.name);
      yield initialList;
    }*/
  }

}