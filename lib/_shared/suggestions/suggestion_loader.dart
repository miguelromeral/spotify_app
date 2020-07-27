import 'dart:convert';
import 'dart:typed_data';

import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:spotify/spotify.dart';

class SuggestionLoader extends StatefulWidget {
  final Suggestion suggestion;
  final MyApi api;
  final key;

  const SuggestionLoader({
    this.key,
    this.suggestion,
    this.api,
  }) : super(key: key);

  @override
  _SuggestionLoaderState createState() => _SuggestionLoaderState();
}

class _SuggestionLoaderState extends State<SuggestionLoader> {
  Future<Track> _track;
  Future<UserPublic> _user;

  @override
  void initState() {
    super.initState();
    _user = widget.api.getUser(widget.suggestion.suserid);
    _track = widget.api.getTrack(widget.suggestion.trackid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: Key(widget.suggestion.fuserid),
      future: _user,
      builder: (context, user) {
        if (user.hasData) {
          return FutureBuilder(
              key: Key(
                  'sl-${widget.suggestion.suserid}-${widget.suggestion.trackid}'),
              future: _track,
              builder: (context, track) {
                if (track.hasData) {
                  return SuggestionItem(
                    key: Key(
                        '${widget.suggestion.suserid}-${widget.suggestion.trackid}'),
                    track: track.data,
                    user: user.data,
                    suggestion: widget.suggestion,
                  );
                } else {
                  //return Container();
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        } else {
          //return Container();
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
