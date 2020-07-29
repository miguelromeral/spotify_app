import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';

class SpotifyService {
  //SpotifyApi _api;
  FirebaseAuthService auth;
  FirestoreService _db;
  bool logedin = false;
  bool demo = false;
  Track toShare;
  bool errorInLogin = false;
  //Following following;
  bool deletingInfo = false;
  bool deletedInfo = false;

  Suggestion lastSuggestion;

  StreamController<Suggestion> _scMySuggestion =
      new StreamController.broadcast();
  Stream<Suggestion> get mySuggestion => _scMySuggestion.stream;

  Following lastFollowing;

  StreamController<Following> _scFollowing = new StreamController.broadcast();
  Stream<Following> get following => _scFollowing.stream;

  User myUser;

  void updateMySuggestion(Suggestion newOne) {
    _scMySuggestion.add(newOne);
    lastSuggestion = newOne;
  }

  void updateFollowing(Following newone) {
    _scFollowing.add(newone);
    lastFollowing = newone;
  }

  void updateMyUser(User me) {
    myUser = me;
  }

  static final String redirectUri = "es.miguelromeral.spotifyapp://login.com";

  SpotifyService();

  SpotifyService.withApi(SpotifyApi miapi) {
    //_api = miapi;
    errorInLogin = false;
  }

  SpotifyService.errorLogin() {
    errorInLogin = true;
  }

  SpotifyService.demo(){
    demo = true;
  }

  bool isInit = false;

  void dispose() {
    _scMySuggestion.close();
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
    //_api = null;
    auth = null;
    _db = null;
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
  
  static Future<SpotifyApi> getSpotifyClient() async {
    var mycredentials = await SpotifyService.readCredentialsFile();
    return SpotifyApi(mycredentials);
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

  Future<bool> deleteUserInfo(String suserid) async => await _db.deleteUserInfo(suserid);

}
