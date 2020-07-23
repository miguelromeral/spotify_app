import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/models/playlists_data.dart';
import 'package:ShareTheMusic/models/saved_tracks_data.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import '../services/local_database.dart';

class PlaylistsBloc extends Bloc<PlaylistsEventBase, PlaylistsData> {
  @override
  PlaylistsData get initialState => PlaylistsData();

  @override
  Stream<PlaylistsData> mapEventToState(PlaylistsEventBase event) async* {
    if (event is UpdatePlaylistsEvent) {
      state.update(event.newOne);
      yield state;
    }
  }

  dipose() {
    state.dispose();
  }
}

class PlaylistsEventBase {}

class UpdatePlaylistsEvent extends PlaylistsEventBase {
  List<PlaylistSimple> newOne;

  UpdatePlaylistsEvent({@required this.newOne});
}