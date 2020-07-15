import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/local_database.dart';

class LocalDbBloc extends Bloc<LocalDbEventBase, LocalDB> {
  // Estado inicial
  @override
  LocalDB get initialState => LocalDB();

  @override
  Stream<LocalDB> mapEventToState(LocalDbEventBase event) async* {
    if(event is InitLocalDbEvent){
      var newOne = LocalDB();
      await newOne.init();
      yield newOne;
    }
    /*if (event is UpdateFeed) {
      print("Updating My Feed in BLOC...");
      state.updateFeed(await _updateFeed(state));
      yield state;
    } else if (event is UpdateMySuggestion) {
      print("Updating My Suggestion in BLOC...");
      state.updateMySuggestion(await _updateMySuggestion(state));
      yield state;
    } else if (event is UpdateSaved) {
      print("Updating My Saved Tracks in BLOC...");
      state.updateSaved(await _updateSaved(state));
      yield state;
    } else if (event is UpdatePlaylists) {
      print("Updating My Playlists in BLOC...");
      state.updatePlaylists(await _updatePlaylists(state));
      yield state;
    } else if (event is LogoutEvent) {
      print("Login out in BLOC...");
      _clearCredentials();
      state.dispose();
      //state.logout();
      SpotifyService newone = SpotifyService();
      yield newone;
    } else {
      throw Exception('oops');
    }*/
  }
}



class LocalDbEventBase {}

class InitLocalDbEvent extends LocalDbEventBase {}
/*
class LoginEvent extends SpotifyEventBase {
  
  bool saveCredentials;
  SpotifyService service;

  LoginEvent(SpotifyApi api, bool remember){
    service = SpotifyService.withApi(api);
    service.login();
    saveCredentials = remember;
  }
}

class UpdateFeed extends SpotifyEventBase {}

class UpdateMySuggestion extends SpotifyEventBase {}

class UpdateSaved extends SpotifyEventBase {}

class UpdatePlaylists extends SpotifyEventBase {}

class LogoutEvent extends SpotifyEventBase {}*/