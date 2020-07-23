import 'dart:async';
import 'package:ShareTheMusic/models/suggestion.dart';

class HomeData {
  StreamController<List<Suggestion>> _scFeed = new StreamController.broadcast();
  Stream<List<Suggestion>> get feed => _scFeed.stream;

  List<Suggestion> _last;
  List<Suggestion> get last => _last ?? List();

  void updateFeed(List<Suggestion> newFeed) {
    _scFeed.add(newFeed);
    _last = newFeed;
  }

  void dispose() {
    _scFeed.close();
  }
}
