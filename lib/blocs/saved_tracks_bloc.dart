import 'package:ShareTheMusic/models/saved_tracks_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';

class SavedTracksBloc extends Bloc<SavedTracksEventBase, SavedTracksData> {
  @override
  SavedTracksData get initialState => SavedTracksData();

  @override
  Stream<SavedTracksData> mapEventToState(SavedTracksEventBase event) async* {
    if (event is UpdateSavedTracksEvent) {
      state.updateSaved(event.newOne);
      yield state;
    }
  }

  dipose(){
    state.dispose();
  }
}

class SavedTracksEventBase {}

class UpdateSavedTracksEvent extends SavedTracksEventBase {
  List<Track> newOne;

  UpdateSavedTracksEvent({@required this.newOne});
}