import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/_shared/suggestions/suggestion_item.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/firestore_db.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  SpotifyBloc _bloc;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return StreamBuilder(
        stream: state.feed,
        builder: (context, snp) {
          if (snp.hasData) {
            List<Suggestion> list = snp.data;
            list.sort((a, b) => b.date.compareTo(a.date));
            return _createList(list, state);
          } else if (snp.hasError) {
            return Center(child: Text('Error while retreiving feed :('));
          } else {
            _getData();
            return Center(child: Text('Loading Feed...'));
            //     return CircularProgressIndicator();
          }
        },
      );
    });
  }

  Widget _createList(List<Suggestion> sugs, SpotifyService state) {
    return NotificationListener<UpdatedFeedNotification>(
      onNotification: (notification) {
        _getData();
        return true;
      },
      child: Flexible(
          child: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: colorSeprator,
                ),
            itemCount: sugs.length,
            itemBuilder: (context, index) =>
                _createListElement(sugs[index], state)),
      )),
    );
  }

  Widget _createListElement(Suggestion item, SpotifyService state) {
    if (item.trackid == FirestoreService.defaultTrackId) {
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
                      return SuggestionItem(
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
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    }
  }

  Future<void> _getData() async {
    if (_bloc != null) {
      _bloc.add(UpdateFeed());
    }
  }
}
