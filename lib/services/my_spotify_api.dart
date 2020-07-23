import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class MyApi {
  SpotifyApi _api;
  bool init = false;

  SpotifyApi get() => (init ? _api : null);

  MyApi() {
    _api = null;
    init = false;
  }

  MyApi.withInstance(SpotifyApi newOne) {
    _api = newOne;
    init = true;
  }

  Future<UserPublic> getUser(String suserid) {
    if (!init) return null;
    return _api.users.get(suserid);
  }

  Future<Track> getTrack(String id) {
    if (!init) return null;
    return _api.tracks.get(id);
  }

  Future<List<Track>> getMySavedTracks() async {
    return (await _api.tracks.me.saved.all()).map((e) => e.track).toList();
  }

  Future<List<PlaylistSimple>> getMyPlaylists() async {
    return (await _api.playlists.me.all()).toList();
  }

  Widget showErrorIfNull(Widget widget) {
    if (!init || _api == null)
      return ErrorScreen(
        title: 'No Spotify API Found',
      );

    return widget;
  }
}
