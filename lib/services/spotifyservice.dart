import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/services.dart' show rootBundle;

class SpotifyService {
  SpotifyApi api;
  bool enabled = false;
  bool logedin = false;

  static final String redirectUri = "es.miguelromeral.spotifyapp://login.com";

  SpotifyService();

  SpotifyService.withApi(SpotifyApi miapi) {
    api = miapi;
    enabled = true;
  }

  //User get myUser => _api == null ? null : _api.me.get();

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
