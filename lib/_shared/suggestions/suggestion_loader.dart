import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

/// Widget that manages the loading of the content for a suggestion
class SuggestionLoader extends StatefulWidget {
  /// Suggestion Info
  final Suggestion suggestion;
  /// Spotify Api to retrieve data
  final MyApi api;
  
  /// Hero Animation for users in 
  final bool heroAnimation;

  const SuggestionLoader({
    Key key,
    this.suggestion,
    this.api,
    this.heroAnimation,
  }) : super(key: key);

  @override
  _SuggestionLoaderState createState() => _SuggestionLoaderState();
}

class _SuggestionLoaderState extends State<SuggestionLoader> {
  /// Track to load
  Future<Track> _track;
  /// User to load
  Future<UserPublic> _user;

  @override
  void initState() {
    super.initState();
    // Initialize data
    _user = widget.api.getUser(widget.suggestion.suserid);
    _track = widget.api.getTrack(widget.suggestion.trackid);
  }

  @override
  Widget build(BuildContext context) {
    // Load the Spotify user
    return FutureBuilder(
      key: Key(widget.suggestion.fuserid),
      future: _user,
      builder: (context, user) {
        if (user.hasData) {
          // Load the Spotify Track
          return FutureBuilder(
              key: Key(
                  'sl-${widget.suggestion.suserid}-${widget.suggestion.trackid}'),
              future: _track,
              builder: (context, track) {
                if (track.hasData) {
                  return SuggestionItem(
                    heroAnimation: widget.heroAnimation,
                    key: Key(
                        '${widget.suggestion.suserid}-${widget.suggestion.trackid}'),
                    track: track.data,
                    user: user.data,
                    suggestion: widget.suggestion,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
