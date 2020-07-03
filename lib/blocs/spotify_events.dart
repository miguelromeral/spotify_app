import 'package:spotify/spotify.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyEventBase {}

class LoginEvent extends SpotifyEventBase {
  
  SpotifyService service;

  LoginEvent(SpotifyApi api){
    service = SpotifyService.withApi(api);
    
    service.logedin = true;
    service.enabled = true;
  }
}
/*
class ShareTrackEvent extends SpotifyEventBase {
  
  Track track;

  ShareTrackEvent({this.track});
}

class ForgetTrackEvent extends SpotifyEventBase {}*/