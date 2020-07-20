import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';

import 'local_database.dart';

class SpotifyService {
  SpotifyApi api;
  FirebaseAuthService auth;
  FirestoreService _db;
  LocalDB _localDB;
  bool logedin = false;
  bool demo = false;
  Track toShare;
  bool errorInLogin = false;
  //Following following;

  StreamController<List<Track>> _scSaved = new StreamController.broadcast();
  Stream<List<Track>> get saved => _scSaved.stream;

  StreamController<List<Suggestion>> _scFeed = new StreamController.broadcast();
  Stream<List<Suggestion>> get feed => _scFeed.stream;

  StreamController<Suggestion> _scMySuggestion =
      new StreamController.broadcast();
  Stream<Suggestion> get mySuggestion => _scMySuggestion.stream;

  StreamController<List<PlaylistSimple>> _scPlaylists =
      new StreamController.broadcast();
  Stream<List<PlaylistSimple>> get playlists => _scPlaylists.stream;

  StreamController<Following> _scFollowing = new StreamController.broadcast();
  Stream<Following> get following => _scFollowing.stream;

  User myUser;

  void updateFeed(List<Suggestion> newFeed) {
    _scFeed.add(newFeed);
  }

  void updateSaved(List<Track> newSaved) {
    _scSaved.add(newSaved);
  }

  void updateMySuggestion(Suggestion newOne) {
    _scMySuggestion.add(newOne);
  }

  void updateFollowing(Following newone) {
    _scFollowing.add(newone);
  }

  void updatePlaylists(List<PlaylistSimple> list) {
    _scPlaylists.add(list);
  }

  void updateMyUser(User me) {
    myUser = me;
  }

  static final String redirectUri = "es.miguelromeral.spotifyapp://login.com";

  SpotifyService();

  SpotifyService.withApi(SpotifyApi miapi) {
    api = miapi;
    errorInLogin = false;
  }

  SpotifyService.errorLogin() {
    errorInLogin = true;
  }

  SpotifyService.demo(){
    demo = true;
  }

  bool isInit = false;

  void init() {
    if (!isInit) {
      _localDB = LocalDB();
      isInit = true;
    }
  }

  void dispose() {
    _scFeed.close();
    _scSaved.close();
    _scMySuggestion.close();
    _scPlaylists.close();
  }

  void shareTrack(Track track) {
    toShare = track;
  }

  void forgetTrack() {
    toShare = null;
  }

  void login() {
    logedin = true;
  }

  void logout() {
    logedin = false;
    api = null;
    auth = null;
    _db = null;
    _localDB = null;
    toShare = null;
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

  /// ****************************************
  ///
  /// LOCAL DB
  ///
  ///**************************************
/*
  Future insertSuggestion(Suggestion sug) async {
    await _localDB.insertSuggestion(sug);
  }

  Future<List<Suggestion>> getSuggestionsBySpotifyUserID(
          String suserid) async =>
      await _localDB.suggestions(suserid);

  Future<List<Suggestion>> getMySuggestions() async =>
      await _localDB.suggestions(_db.spotifyUserID);
*/
  /// ****************************************
  ///
  /// FIRESTORE DB
  ///
  ///**************************************

  void updateDB(FirestoreService db) {
    _db = db;
  }

  bool firebaseUserIdEquals(String fuserid) {
    return _db.firebaseUserID == fuserid;
  }

  Future likeSuggestion(Suggestion sug) async {
    return await _db.likeSuggestion(sug);
  }

  Future followUnfollow(BuildContext context, Following following,
      Following myFollowings, bool currentlyFollowing, UserPublic user) async {
    if (_db.firebaseUserID != following.fuserid) {
      if (currentlyFollowing) {
        await _db.removeFollowing(myFollowings, user.id);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('You no longer follow ${user.displayName}!')));
      } else {
        await _db.addFollowing(myFollowings, user.id);
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('You followed ${user.displayName}!')));
      }

      BlocProvider.of<SpotifyBloc>(context).add(UpdateFeed());
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
    }
  }

  Future<Suggestion> updateUserData(
          String spotifyuserid, String trackid, String text) async =>
      await _db.updateUserData(spotifyuserid, trackid, text);

  Future<Suggestion> getMySuggestion() async => await _db.getMySuggestion();

  Future<Suggestion> getSuggestion(String suserid) async =>
      await _db.getSuggestion(suserid);

  Future<List<Following>> searchFollowing(String query) async =>
      await _db.searchFollowing(query);

  Future<Following> getMyFollowing() async => await _db.getMyFollowing();

  String get myFirebaseUserId => _db.firebaseUserID;

  String get mySpotifyUserId => _db.spotifyUserID;

  Future<bool> addFollowing(Following fol, String suserid) async =>
      await _db.addFollowing(fol, suserid);

  Future removeFollowing(Following fol, String suserid) async =>
      await _db.removeFollowing(fol, suserid);

  Future<Following> getFollowingBySpotifyUserID(String suserid) async =>
      await _db.getFollowingBySpotifyUserID(suserid);

  Future<bool> addFollowingByUserId(String suserid) async =>
      await _db.addFollowingByUserId(suserid);

  Stream<List<Following>> get allFollowings => _db.following;

  Future<List<Suggestion>> getsuggestions() async => await _db.getsuggestions();

  Future<List<Suggestion>> getPublicSuggestions() async => await _db.getPublicSuggestions();

  Future<List<Following>> getFollowers(String suserid) async => await _db.getFollowers(suserid);

}
