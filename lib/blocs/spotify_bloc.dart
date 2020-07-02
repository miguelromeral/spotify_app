// Al Bloc extenderá del tipo de evento y la clase del estado que guardará
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
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
      /*  AuthService _auth = AuthService();
        String email = "";
        String pwd = "";
   */   try {
        var cred = await event.service.api.getCredentials();
        _saveCredentials(cred);
    /*    var user = await event.service.api.me.get();
        email = user.email;
        pwd = PasswordGenerator.generatePassword(user);
        dynamic result = await _auth.signInWithEmailAndPassword(email, pwd);
        print("Result: $result");
      } on PlatformException catch (err) {
        print("Error while login: PlatformException: $err");
        if(err.code == "ERROR_USER_NOT_FOUND"){
          try{
            dynamic result = await _auth.registerWithEmailAndPassword(email, pwd);
            dynamic r2 = await _auth.signInWithEmailAndPassword(email, pwd);
          }catch(e){
            print("Error while registering new user and login in again: $e");
          }
        }
  */    } catch (e) {
        print("Error while login: $e");
      }

      yield event.service;
    } else {
      throw Exception('oops');
    }
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


