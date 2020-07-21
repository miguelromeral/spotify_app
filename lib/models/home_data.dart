import 'dart:async';
import 'package:ShareTheMusic/models/suggestion.dart';

class HomeData {
  StreamController<List<Suggestion>> _scFeed = new StreamController.broadcast();
  Stream<List<Suggestion>> get feed => _scFeed.stream;

  void updateFeed(List<Suggestion> newFeed) {
    _scFeed.add(newFeed);
  }

  void dispose() {
    _scFeed.close();
  }
}
