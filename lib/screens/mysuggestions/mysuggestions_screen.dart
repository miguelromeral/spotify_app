import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/blocs/localdb_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/local_database.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestions_screen.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';

class MySuggestionsScreen extends StatefulWidget {
  @override
  _MySuggestionsScreenState createState() => _MySuggestionsScreenState();
}

class _MySuggestionsScreenState extends State<MySuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return FancyBackgroundApp(
      child:
          BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
        return BlocBuilder<ApiBloc, MyApi>(
          builder: (context, api) => BlocBuilder<LocalDbBloc, LocalDB>(
            //condition: (pre, cur) => pre.isInit != cur.isInit,
            builder: (context, localdb) => _buildBody(localdb, state, api),
          ),
        );
      }),
    );
  }

  Widget _buildWidgetHeader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
            "Here are all the suggestions you've sent by this device linked with your user."),
      ),
    );
  }

  Widget _buildBody(LocalDB localdb, SpotifyService state, MyApi api) {
    if (localdb != null && localdb.isInit) {
      return FutureBuilder(
        future: localdb.suggestions(state.mySpotifyUserId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Suggestion> list = snapshot.data;

            var last = state.lastSuggestion;
            if (last != null) {
              list.add(last);
            }

            list.sort((one, two) => two.date.compareTo(one.date));
            return SuggestionsScreen(
              widget: _buildWidgetHeader(),
              title: 'My Suggestions',
              list: list,
              loading: false,
              api: api,
            );
            /*
            if (list.isNotEmpty) {
              return SuggestionsList(
                suggestions: list,
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('My Suggestions'),
                  centerTitle: true,
                ),
                body: ErrorScreen(
                  safeArea: true,
                  title: 'Nothing to see here... yet.',
                  stringBelow: [
                    "You have not sent any track from this device.",
                    "Once you've updated your suggestion you'll see them here."
                  ],
                ),
              );
            }*/
          } else {
            return SuggestionsScreen(
              widget: _buildWidgetHeader(),
              title: 'My Suggestions',
              list: List(),
              loading: true,
              api: api,
            );
          }
        },
      );
    } else {
      BlocProvider.of<LocalDbBloc>(context).add(InitLocalDbEvent());
      BlocProvider.of<SpotifyBloc>(context).add((UpdateMySuggestion()));

      return SuggestionsScreen(
        widget: _buildWidgetHeader(),
        title: 'My Suggestions',
        list: List(),
        loading: true,
        api: api,
      );
    }
  }
}
