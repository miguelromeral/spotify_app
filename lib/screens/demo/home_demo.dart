import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestions_screen.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class HomeScreenDemo extends StatefulWidget {
  @override
  _HomeScreenDemoState createState() => _HomeScreenDemoState();
}

class _HomeScreenDemoState extends State<HomeScreenDemo> {
  //List<Suggestion> _storage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, MyApi>(
        builder: (context, api) =>
            api.showErrorIfNull(BlocBuilder<HomeBloc, HomeData>(
              builder: (context, data) {
                return BlocBuilder<SpotifyBloc, SpotifyService>(
                  builder: (context, state) {
                    return Center(
                      child: FutureBuilder(
                        future: _getData(context, state),
                        builder: (context, snp) {
                          if (snp.hasData) {
                            return buildBody(context, api, state, snp.data);
                          } else {
                            return LoadingScreen();
                          }
                        },
                      ),
                    );
                  },
                );
              },
            )));
  }

  Widget buildBody(BuildContext context, MyApi api, SpotifyService state,
      List<Suggestion> list) {
    return NotificationListener<UpdatedFeedNotification>(
      onNotification: (notification) {
        _getData(context, state);
        return true;
      },
      child: _create(context, api, state, list),
    );
  }

  Widget _create(BuildContext context, MyApi api, SpotifyService state,
      List<Suggestion> list) {
    List<Suggestion> l = list;
    bool loading = false;
    if (list == null) {
      l = List<Suggestion>();
      loading = true;
    }

    list.insert(
        0,
        Suggestion(
          date: DateTime.now(),
          fuserid: 'unk',
          likes: 24,
          private: false,
          suserid: 'pave0j052dcrnkn9iai47wy0j',
          trackid: '4u7EnebtmKWzUH433cf5Qv',
          text: "Hi, there and welcome to ShareTheTrack DEMO!\n"
          "\n"
          "This is a DEMO suggestions.\n"
          "\n"
          "In the full version you can vote any of these, browse in your playlists and also choose one of them as your suggestion.\n"
          "\n"
          "\n"
          "\n"
          "Keep scrolling to take a look to the suggestions some users wanted to share with the anonimous users."
          "\n",
        ));

    return NotificationListener<RefreshListNotification>(
      onNotification: (not) {
        _getData(context, state);
        return true;
      },
      child: SuggestionsScreen(
        title: 'Public Suggestions (DEMO)',
        list: l,
        loading: loading,
        api: api,
      ),
    );
  }

  Future<List<Suggestion>> _getData(
      BuildContext context, SpotifyService state) async {
    return await state.getPublicSuggestions();
  }
}
