import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/password_generator.dart';
import 'spotify_events.dart';

class SpotifyBloc extends Bloc<SpotifyEventBase, SpotifyService> {
  // Estado inicial
  @override
  SpotifyService get initialState => SpotifyService();

  @override
  Stream<SpotifyService> mapEventToState(SpotifyEventBase event) async* {
    if (event is LoginEvent) {
      FirebaseAuthService _auth = FirebaseAuthService();
      FirestoreService _db;
      String email = "";
      String pwd = "";
      User user;
      try {
        var cred = await event.service.api.getCredentials();
        //if (event.saveCredentials) {
        _saveCredentials(cred);
        //} else {
        //  _clearCredentials();
        //}
        user = await event.service.api.me.get();
        email = user.email;
        pwd = PasswordGenerator.generatePassword(user);
        _db = await _login(_auth, email, pwd, user.id);
        event.service.updateMyUser(user);
        _db.updateDisplayName(user);
        print("Logged $email.");
      } on PlatformException catch (err) {
        print("Error while login: PlatformException: $err");
        if (err.code == "ERROR_USER_NOT_FOUND") {
          try {
            dynamic firebaseuser =
                await _auth.registerWithEmailAndPassword(email, pwd);
            _db = await _login(_auth, email, pwd, user.id);
            event.service.updateMyUser(user);
            _db.updateDisplayName(user);
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
        /*} on Authori catch (ae) {
        if(ae.error == 'invalid_grant'){

        }
        yield SpotifyService();*/
      } catch (ae) {
        print("Error while login: $ae");
        yield SpotifyService.errorLogin();
        return;
      }
      event.service.updateDB(_db);
      event.service.init();
      event.service.auth = _auth;
      _load(event.service);
      yield event.service;
    } else if (event is UpdateFeed) {
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
    }
  }

  Future _load(SpotifyService service) async {
    service.updateFollowing(await _updateFollowing(service));
    service.updateMySuggestion(await _updateMySuggestion(service));
    service.updateFeed(await _updateFeed(service));
    //service.updateSaved(await _updateSaved(service));
    //service.updatePlaylists(await _updatePlaylists(service));
  }

  Future<Following> _updateFollowing(SpotifyService state) async {
    return await state.getMyFollowing();
  }

  Future<Suggestion> _updateMySuggestion(SpotifyService state) async {
    return await state.getMySuggestion();
  }

  Future<List<Suggestion>> _updateFeed(SpotifyService state) async {
    state.updateFollowing(await _updateFollowing(state));
    return await state.getsuggestions();
  }

  Future<List<Track>> _updateSaved(SpotifyService state) async {
    List<Track> list =
        (await state.api.tracks.me.saved.all()).map((e) => e.track).toList();
    print("Updated Saved, last: ${list.first.name} (${list.length})!");
    return list;
  }

  Future<List<PlaylistSimple>> _updatePlaylists(SpotifyService state) async {
    List<PlaylistSimple> list = (await state.api.playlists.me.all()).toList();
    print("Updated playlists, (${list.length})!");
    return list;
  }

  Future<FirestoreService> _login(FirebaseAuthService _auth, String email,
      String pwd, String suserid) async {
    var user = await _auth.signInWithEmailAndPassword(email, pwd);
    FirestoreService _db =
        FirestoreService(spotifyUserID: suserid, firebaseUserID: user.uid);
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

  Future _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", '');
    prefs.setString("clientId", '');
    prefs.setString("clientSecret", '');
    prefs.setString("refreshToken", '');
    prefs.setStringList("scopes", List());
    prefs.setString("expiration", '');
  }
}




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