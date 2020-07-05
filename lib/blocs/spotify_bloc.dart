// Al Bloc extenderá del tipo de evento y la clase del estado que guardará
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/DatabaseService.dart';
import 'package:spotify_app/services/auth.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:spotify_app/services/password_generator.dart';

class SpotifyBloc extends Bloc<SpotifyEventBase, SpotifyService> {
  // Estado inicial
  @override
  SpotifyService get initialState => SpotifyService();

  @override
  Stream<SpotifyService> mapEventToState(SpotifyEventBase event) async* {
    if (event is LoginEvent) {
      AuthService _auth = AuthService();
      DatabaseService _db;
      String email = "";
      String pwd = "";
      User user;
      try {
        var cred = await event.service.api.getCredentials();
        _saveCredentials(cred);
        user = await event.service.api.me.get();
        email = user.email;
        pwd = PasswordGenerator.generatePassword(user);
        _db = await _login(_auth, email, pwd, user.id);
        print("Logged $email.");
      } on PlatformException catch (err) {
        print("Error while login: PlatformException: $err");
        if (err.code == "ERROR_USER_NOT_FOUND") {
          try {
            dynamic firebaseuser =
                await _auth.registerWithEmailAndPassword(email, pwd);
            _db = await _login(_auth, email, pwd, user.id);
            _db.initializeFollowing();
            /*if (user != null && firebaseuser is FirebaseUser) {
              _db = DatabaseService(firebaseUserID: firebaseuser.uid);
              await _db.updateUserData(user.id, DatabaseService.defaultTrackId);
            }*/
            print("Registered $email and loged in successfully.");
          } catch (e) {
            print("Error while registering new user and login in again: $e");
          }
        }
      } catch (e) {
        print("Error while login: $e");
      }
      event.service.db = _db;
      event.service.furueSuggestions = _db.getsuggestions();
      event.service.auth = _auth;
      yield event.service;
    } else if (event is UpdateFeed) {
      state.furueSuggestions = state.db.getsuggestions();
      state.lastSuggestionUpdate = DateTime.now();
      print("Updated Suggestions!");
      yield state;
    } else if(event is UpdateFollowing){
      var news = await state.db.getFollowing();
      SpotifyService newState = state;
      newState.following = news;
      //state.following = news;
      print("Updated Following!");
      yield newState;
    } else if (event is UpdateMySuggestion) {
      state.mySuggestion = await state.db.getMySuggestion();
      yield state;
    } else {
      throw Exception('oops');
    }
  }

  Future<DatabaseService> _login(
      AuthService _auth, String email, String pwd, String suserid) async {
    var user = await _auth.signInWithEmailAndPassword(email, pwd);
    DatabaseService _db =
        DatabaseService(spotifyUserID: suserid, firebaseUserID: user.uid);
    return _db;
  }

  Future _saveCredentials(SpotifyApiCredentials cred) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", cred.accessToken);
    prefs.setString("clientId", cred.clientId);
    prefs.setString("clientSecret", cred.clientSecret);
    prefs.setString("refreshToken", cred.refreshToken);
    prefs.setStringList("scopes", cred.scopes);
    prefs.setString("expiration", cred.expiration.toString());
  }
}
