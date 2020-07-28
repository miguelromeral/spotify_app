import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/password_generator.dart';

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
        var cred = await event.api.getCredentials();
        //if (event.saveCredentials) {
        _saveCredentials(cred);
        //} else {
        //  _clearCredentials();
        //}
        user = await event.api.me.get();
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

            if (firebaseuser == null) throw Exception("Error while singing up");
            _db = await _login(_auth, email, pwd, user.id);
            event.service.updateMyUser(user);
            _db.initializeFollowing();
            _db.updateDisplayName(user);
            /*if (user != null && firebaseuser is FirebaseUser) {
              _db = DatabaseService(firebaseUserID: firebaseuser.uid);
              await _db.updateUserData(user.id, DatabaseService.defaultTrackId);
            }*/
            print("Registered $email and loged in successfully.");
          } catch (e) {
            print("Error while registering new user and login in again: $e");
            yield SpotifyService.errorLogin();
            return;
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
      event.service.auth = _auth;
      _load(event.service);
      yield event.service;
    } else if (event is UpdateFeed) {
      //print("Updating My Feed in BLOC...");
      //state.updateFeed(await _updateFeed(state));
      //yield state;
    } else if (event is UpdateMySuggestion) {
      print("Updating My Suggestion in BLOC...");
      state.updateMySuggestion(await _updateMySuggestion(state));
      yield state;
    } else if (event is UpdateFollowing) {
      state.updateFollowing(await _updateFollowing(state));
      yield state;
    } else if (event is UpdatePlaylists) {
      //print("Updating My Playlists in BLOC...");
      //state.updatePlaylists(await _updatePlaylists(state, event.api));
      //yield state;
    } else if (event is LogoutEvent) {
      _clearCredentials();
      state.dispose();
      //state.logout();
      SpotifyService newone = SpotifyService();
      yield newone;
    } else if (event is LoginAnonymousEvent) {
      SpotifyService demo = SpotifyService.demo();

      try {
        FirebaseAuthService _auth = FirebaseAuthService();
        var user = await _auth.signInAnon();
        if (user == null) {
          throw Exception("No anonymous user loged.");
        }
        demo.auth = _auth;

        //var mycredentials = await SpotifyService.readCredentialsFile();
        //final spotify = SpotifyApi(mycredentials);
        //demo.api = spotify;
        print("Logged anonymously");
      } catch (ae) {
        print("Error while login: $ae");
        yield SpotifyService.errorLogin();
        return;
      }
      demo.login();
      demo.updateDB(FirestoreService());
      yield demo;
    } else if (event is DeleteInfoEvent) {
      state.deletingInfo = true;
      yield state;
      _clearCredentials();
      SpotifyService newone = SpotifyService();
      await state.deleteUserInfo(event.suserid);
      newone.deletedInfo = true;
      state.dispose();
      //state.logout();
      yield newone;
    } else {
      throw Exception('oops');
    }
  }

  Future _load(SpotifyService service) async {
    service.updateFollowing(await _updateFollowing(service));
    service.updateMySuggestion(await _updateMySuggestion(service));
    //service.updateFeed(await _updateFeed(service));
    //service.updateSaved(await _updateSaved(service));
    //service.updatePlaylists(await _updatePlaylists(service));
  }

  Future<Following> _updateFollowing(SpotifyService state) async {
    return await state.getMyFollowing();
  }

  Future<Suggestion> _updateMySuggestion(SpotifyService state) async {
    return await state.getMySuggestion();
  }

/*
  Future<List<Suggestion>> _updateFeed(SpotifyService state) async {
    state.updateFollowing(await _updateFollowing(state));
    return await state.getsuggestions();
  }

  Future<List<Track>> _updateSaved(SpotifyService state, SpotifyApi api) async {
    List<Track> list =
        (await api.tracks.me.saved.all()).map((e) => e.track).toList();
    print("Updated Saved, last: ${list.first.name} (${list.length})!");
    return list;
  }

  Future<List<PlaylistSimple>> _updatePlaylists(SpotifyService state, SpotifyApi api) async {
    List<PlaylistSimple> list = (await api.playlists.me.all()).toList();
    print("Updated playlists, (${list.length})!");
    return list;
  }
*/
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
  SpotifyApi api;
  SpotifyService service;

  LoginEvent(SpotifyApi sapi, bool remember) {
    service = SpotifyService.withApi(sapi);
    api = sapi;
    service.login();
    saveCredentials = remember;
  }
}

class UpdateFeed extends SpotifyEventBase {}

class UpdateMySuggestion extends SpotifyEventBase {}

class UpdateSaved extends SpotifyEventBase {
  SpotifyApi api;

  UpdateSaved({@required this.api});
}

class UpdateFollowing extends SpotifyEventBase {}

class UpdatePlaylists extends SpotifyEventBase {
  SpotifyApi api;

  UpdatePlaylists({@required this.api});
}

class LogoutEvent extends SpotifyEventBase {}

class LoginAnonymousEvent extends SpotifyEventBase {}

class DeleteInfoEvent extends SpotifyEventBase {
  String suserid;

  DeleteInfoEvent({this.suserid});
}
