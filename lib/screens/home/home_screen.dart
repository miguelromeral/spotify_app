import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestions_screen.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

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
    if (liked == null) {
      l = List<Suggestion>();
      loading = true;
    }

    return NotificationListener<RefreshListNotification>(
      onNotification: (not) {
        _getData(context, state);
        return true;
      },
      child: SuggestionsScreen(
        title: 'My Friends Suggestions',
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
