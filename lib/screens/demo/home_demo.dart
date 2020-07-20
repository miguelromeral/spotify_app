import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/custom_sliver_appbar.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/custom_appbar.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import '../styles.dart';

class HomeScreenDemo extends StatefulWidget {
  @override
  _HomeScreenDemoState createState() => _HomeScreenDemoState();
}

class _HomeScreenDemoState extends State<HomeScreenDemo> {
  SpotifyBloc _bloc;

  Widget _createScaffold(Widget content) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My DEMO Suggestions'),
        centerTitle: true,
      ),
      body: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return Center(
        child: FutureBuilder(
          future: state.getPublicSuggestions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Suggestion> list = snapshot.data;
              list.sort((a, b) => b.date.compareTo(a.date));
              return _createList(list, state);
            } else if (snapshot.hasError) {
              return ErrorScreen();
            } else {
              return LoadingScreen();
            }
          },
        ),
      );
    });
  }

  Widget _createList(List<Suggestion> sugs, SpotifyService state) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          CustomSliverAppBar(title: 'My Firends Suggestion', state: state),
        ],
        body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: colorSeprator,
                ),
            itemCount: sugs.length,
            itemBuilder: (context, index) =>
                _createListElement(sugs[index], state)),
      ),
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
          });
    }
  }
}
