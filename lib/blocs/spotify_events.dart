import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

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

/*
class ShareTrackEvent extends SpotifyEventBase {
  
  Track track;

  ShareTrackEvent({this.track});
}

class ForgetTrackEvent extends SpotifyEventBase {}*/