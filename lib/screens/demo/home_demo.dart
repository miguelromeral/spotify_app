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

import '../styles.dart';

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
    Widget widget = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorAccent.withAlpha(50),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Hi there! and welcome to ShareTheTrack DEMO version!",
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "In this screen you'd see the suggestions users you're following have updated. "
                    "In this case, you are seing some users suggestions that they wanted to share with all the demo users "
                    "so as to you be able to see how the app works.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                      "If you like them and you want to vote for their tracks, then log in with Spotify, follow them vote for their suggestions.",
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    list.insert(
        0,
        Suggestion(
          date: DateTime.now(),
          fuserid: 'unk',
          likes: 24,
          private: false,
          suserid: 'pave0j052dcrnkn9iai47wy0j',
          trackid: '4u7EnebtmKWzUH433cf5Qv',
          text: "Easy come, easy go\n"
              "Will you let me go?\n"
              "\n"
              "Bismillah!\n"
              "No, we will not let you go!\n",
        ));

    return NotificationListener<RefreshListNotification>(
      onNotification: (not) {
        _getData(context, state);
        return true;
      },
      child: SuggestionsScreen(
        title: 'Public Suggestions (DEMO)',
        list: l,
        widget: widget,
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
