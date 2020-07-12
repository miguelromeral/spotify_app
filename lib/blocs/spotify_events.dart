import 'package:spotify/spotify.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class SpotifyEventBase {}

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

class LogoutEvent extends SpotifyEventBase {}