import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/mysuggestions/mysuggestions_screen.dart';
import 'package:spotify_app/services/firestore_db.dart';
import 'package:spotify_app/services/auth.dart';

import 'local_database.dart';

class SpotifyService {
  SpotifyApi api;
  AuthService auth;
  FirestoreService db;
  LocalDB localDB;
  bool logedin = false;
  Track toShare;
  //Following following;

  StreamController<List<Track>> _scSaved = new StreamController.broadcast();
  Stream<List<Track>> get saved => _scSaved.stream;

  StreamController<List<Suggestion>> _scFeed = new StreamController.broadcast();
  Stream<List<Suggestion>> get feed => _scFeed.stream;

  StreamController<Suggestion> _scMySuggestion = new StreamController.broadcast();
  Stream<Suggestion> get mySuggestion => _scMySuggestion.stream;

  StreamController<List<PlaylistSimple>> _scPlaylists = new StreamController.broadcast();
  Stream<List<PlaylistSimple>> get playlists => _scPlaylists.stream;

  StreamController<Following> _scFollowing = new StreamController.broadcast();
  Stream<Following> get following => _scFollowing.stream;

  void updateFeed(List<Suggestion> newFeed){
    _scFeed.add(newFeed);
  }

  void updateSaved(List<Track> newSaved){
    _scSaved.add(newSaved);
  }

  void updateMySuggestion(Suggestion newOne){
    _scMySuggestion.add(newOne);
  }

  void updateFollowing(Following newone){
    _scFollowing.add(newone);
  }

  void updatePlaylists(List<PlaylistSimple> list){
    _scPlaylists.add(list);
  }

  static final String redirectUri = "es.miguelromeral.spotifyapp://login.com";

  SpotifyService();

  SpotifyService.withApi(SpotifyApi miapi) {
    api = miapi;
  }

  void dispose(){
    _scFeed.close();
    _scSaved.close();
    _scMySuggestion.close();
    _scPlaylists.close();
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
