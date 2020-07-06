import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/home/feed_item.dart';
import 'package:spotify_app/services/DatabaseService.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class SuggestionsList extends StatefulWidget {
  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  SpotifyBloc _bloc;
  DateTime lastUpdate;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      if (state.feed != null && state.feed.length > 0) {
        List<Suggestion> sugs = state.feed;
        return NotificationListener<UpdatedFeedNotification>(
          onNotification: (notification) {
            _getData();
            return true;
          },
          //child: RefreshIndicator(
          //  onRefresh: _getData,
          child: Flexible(
              child: RefreshIndicator(
            onRefresh: _getData,
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
                                      suggestion: item,
                                    );
                                  } else if (snp.hasError) {
                                    return Center(
                                        child: Text(
                                      snp.error.toString(),
                                    ));
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
                }),
          )),
        );
      } else {
        _getData();
        //BlocProvider.of<SpotifyBloc>(context).add(UpdateFeed());

        return Center(child: Text('oops, no feed.'));
        //     return CircularProgressIndicator();
      }
    });
  }

  Future<void> _getData() async {
    if (_bloc != null) {
      _bloc.add(UpdateFeed());
      setState(() {
        lastUpdate = DateTime.now();
      });
    }
  }
}
