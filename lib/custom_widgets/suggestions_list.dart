import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/custom_widgets/feed_item.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/services/DatabaseService.dart';

import 'album_picture.dart';

class SuggestionsList extends StatefulWidget {
  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  @override
  Widget build(BuildContext context) {
    final sugs = Provider.of<List<Suggestion>>(context);
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return Flexible(
        child: ListView.builder(
            itemCount: sugs.length,
            itemBuilder: (context, index) {
              var item = sugs[index];
              if (item.trackid == DatabaseService.defaultTrackId) {
                return Container();
              } else {
                return FutureBuilder(
                    future: state.api.tracks.get(item.trackid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Track track = snapshot.data;
                        return FutureBuilder(
                            future: state.api.users.get(item.suserid),
                            builder: (context, snp) {
                              if (snp.hasData) {
                                UserPublic user = snp.data;
                                return FeedItem(
                                  track: track,
                                  user: user,
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              }
            }));
  }
}
