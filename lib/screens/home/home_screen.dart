import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestions_screen.dart';
import 'package:ShareTheMusic/screens/tabs_page.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import '../../services/styles.dart';

class HomeScreen extends StatefulWidget {
  static Key pageKey = new PageStorageKey("homescreen");

  HomeScreen() : super(key: pageKey);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<Suggestion> _storage;

  @override
  void initState() {
    super.initState();

    /*_storage = PageStorage.of(context)
            .readState(context, identifier: ValueKey(HomeScreen.pageKey)) ??
        List();*/
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
                      child: StreamBuilder(
                        stream: data.feed,
                        builder: (context, snp) {
                          if (snp.hasData) {
                            return buildBody(context, api, snp.data, state);
                          } else if (data.last.isNotEmpty) {
                            return buildBody(context, api, data.last, state);
                            /*} else if (snp.hasError) {
                            return _createScaffold(ErrorScreen(
                              title: 'Error while retrieving your feed.',
                            ));*/
                          } else {
                            _getData(context, state);
                            return buildBody(context, api, null, state);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            )));
  }

  Widget buildBody(BuildContext context, MyApi api, List<Suggestion> liked,
      SpotifyService state) {
    return NotificationListener<UpdatedFeedNotification>(
      onNotification: (notification) {
        _getData(context, state);
        return true;
      },
      child: _create(context, api, liked, state),
    );
  }

  Widget _create(BuildContext context, MyApi api, List<Suggestion> liked,
      SpotifyService state) {
    List<Suggestion> l = liked;
    bool loading = false;
    Widget widget = null;
    if (liked == null) {
      l = List<Suggestion>();
      loading = true;
    }
    if (liked != null && liked.isEmpty) {
      widget = Padding(
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
                    Text(
                        "It seems you have no suggestions in your feed, haven't you?", textAlign: TextAlign.center),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text("Don't worry, there are two ways to solve this:", textAlign: TextAlign.center),
                    SizedBox(
                      height: 24.0,
                    ),
                    RaisedButton(
                        child: Text("SEARCH USERS AND FOLLOW THEM"),
                        textColor: Colors.black,
                        color: colorAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: colorPrimary)),
                        onPressed: () {
                          navigateAllUsers(context);
                        }),
                    SizedBox(
                      height: 8.0,
                    ),
                    RaisedButton(
                        child: Text("GO TO LIKED SONGS AND SEND A SUGGESTION"),
                        textColor: Colors.black,
                        color: colorAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: colorPrimary)),
                        onPressed: () {
                          ChangePageNotification(index: 2).dispatch(context);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return NotificationListener<RefreshListNotification>(
      onNotification: (not) {
        _getData(context, state);
        return true;
      },
      child: SuggestionsScreen(
        title: 'My Friends Suggestions',
        header: widget,
        //key: Key(l.hashCode.toString()),
        list: l,
        loading: loading,
        api: api,
      ),
    );
  }

  Future<void> _getData(BuildContext context, SpotifyService state) async {
    print("Getting Latest Feed");
    BlocProvider.of<HomeBloc>(context)
        .add(UpdateFeedHomeEvent(suggestions: await state.getsuggestions()));
    await Future.delayed(Duration(seconds: 10));
  }
}
