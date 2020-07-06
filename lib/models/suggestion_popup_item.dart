
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';

enum PopupAction { listen, vote }

class FeedPopupAction {
  Track track;
  Suggestion suggestion;
  PopupAction action;

  FeedPopupAction({this.track, this.suggestion, this.action});
}
