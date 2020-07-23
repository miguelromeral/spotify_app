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
  Track _track;
  UserPublic _user;
  SuggestionItem _item;

  @override
  void initState() {
    super.initState();

    var r = PageStorage.of(context)
        .readState(context, identifier: ValueKey(widget.key));

    if (r == null) {
      _load();
    }
  }

  Future _load() async {
    if (_user == null) {
      print("Getting User ${widget.suggestion.suserid}");
      var u = await widget.api.getUser(widget.suggestion.suserid);
      setState(() {
        _user = u;
      });
    }
    if (_track == null) {
      print("Getting Track ${widget.suggestion.suserid}");

      var t = await widget.api.getTrack(widget.suggestion.trackid);

      setState(() {
        _track = t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return LoadingScreen(
        title: 'Loading User...',
      );
    }
    if (_track == null) {
      return LoadingScreen(
        title: 'Loading Track...',
      );
    }
    return SuggestionItem(
      track: _track,
      user: _user,
      suggestion: widget.suggestion,
    );

    /*return FutureBuilder(
        future: widget.api.tracks.get(widget.suggestion.trackid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Track track = snapshot.data;
            return FutureBuilder(
                future: widget.api.users.get(widget.suggestion.suserid),
                builder: (context, snp) {
                  if (snp.hasData) {
                    UserPublic user = snp.data;
                    return SuggestionItem(
                      track: track,
                      user: user,
                      suggestion: widget.suggestion,
                    );
                  } else if (snp.hasError) {
                    return ErrorScreen(
                      title: 'User Not Found',
                      stringBelow: ['Reload Feed Later'],
                      collapsed: true,
                    );
                  } else {
                    return LoadingScreen(
                      title: 'Loading User...',
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return ErrorScreen(
              title: 'Track Not Found',
              stringBelow: ['Reload Feed Later'],
              collapsed: true,
            );
          } else {
            return LoadingScreen(
              title: 'Loading Track...',
            );
          }
        });*/
  }
}
