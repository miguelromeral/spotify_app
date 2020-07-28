import 'dart:async';
import 'package:spotify/spotify.dart';

class SavedTracksData {
  
  StreamController<List<Track>> _scSaved = new StreamController.broadcast();
  Stream<List<Track>> get saved => _scSaved.stream;
  
  List<Track> _last;
  List<Track> get last => _last ?? List();

  void updateSaved(List<Track> newFeed) {
    _scSaved.add(newFeed);
    _last = newFeed;
    print("Updated: #${newFeed.length} - last: ${newFeed.first.name}");
  }

  void dispose() {
    _scSaved.close();
  }
}
