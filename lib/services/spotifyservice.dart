import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/services/DatabaseService.dart';
import 'package:spotify_app/services/auth.dart';

class SpotifyService {
  SpotifyApi api;
  AuthService auth;
  DatabaseService db;
  bool enabled = false;
  bool logedin = false;
  Track toShare;
  Future furueSuggestions;

  static final String redirectUri = "es.miguelromeral.spotifyapp://login.com";

  SpotifyService();

  SpotifyService.withApi(SpotifyApi miapi) {
    api = miapi;
    enabled = true;
  }

  void shareTrack(Track track){
    toShare = track;
  }

  void forgetTrack(){
    toShare = null;
  }

  Future<User> get myUser => api == null ? null : api.me.get();

  Future<Iterable<PlaylistSimple>> get myPlaylists => api == null ? null : api.playlists.me.all(); 

  void getFollowers(Me me){
    var following = me.following(FollowingType.artist);
    /*for(var f in following){
      print
    }*/
    print("Following: $following");
  }

  void login() {
    logedin = true;
  }

  void logout() {
    logedin = false;
  }

  static Future<SpotifyApiCredentials> readCredentialsFile() async {
    try {
      var keyJson = await rootBundle.loadString('credentials.json');
      var keyMap = json.decode(keyJson);
      return SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
