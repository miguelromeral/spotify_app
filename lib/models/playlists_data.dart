import 'dart:async';
import 'package:spotify/spotify.dart';

class PlaylistsData {
  StreamController<List<PlaylistSimple>> _scPlaylists =
      new StreamController.broadcast();
  Stream<List<PlaylistSimple>> get playlists => _scPlaylists.stream;

  List<PlaylistSimple> _last;
  List<PlaylistSimple> get last => _last ?? List();

  void update(List<PlaylistSimple> newFeed) {
    _scPlaylists.add(newFeed);
    _last = newFeed;
  }

  void dispose() {
    _scPlaylists.close();
  }
}
