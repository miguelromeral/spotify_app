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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpotifyBloc _bloc;

  Widget _createScaffold(Widget content) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'My Friend Suggestions',
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
        child: StreamBuilder(
          stream: state.feed,
          builder: (context, snp) {
            if (snp.hasData) {
              List<Suggestion> list = snp.data;
              list.sort((a, b) => b.date.compareTo(a.date));
              return _createList(list, state);
            } else if (snp.hasError) {
              return _createScaffold(ErrorScreen(
                title: 'Error while retrieving your feed.',
              ));
            } else {
              _getData();
              return _createScaffold(LoadingScreen(
                title: 'Loading Feed...',
              ));
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
        body: NotificationListener<UpdatedFeedNotification>(
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
        ),
      ),
    );

    /*return CustomScrollView(slivers: <Widget>[
      CustomSliverAppBar(title: 'My Firends Suggestion', state: state),
      SliverList(
        delegate: SliverChildBuilderDelegate((_, int index) {
          if (index < sugs.length)
            return _createListElement(sugs[index], state);
        }),
      ),
    ]);*/

    /*
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
    );*/
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

  Future<void> _getData() async {
    if (_bloc != null) {
      _bloc.add(UpdateFeed());
      await Future.delayed(Duration(seconds: 2));
    }
  }
}
