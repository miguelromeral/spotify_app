import 'package:ShareTheMusic/blocs/localdb_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/screens/mysuggestions/suggestions_list.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/local_database.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class MySuggestionsScreen extends StatefulWidget {
  @override
  _MySuggestionsScreenState createState() => _MySuggestionsScreenState();
}

class _MySuggestionsScreenState extends State<MySuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return BlocBuilder<LocalDbBloc, LocalDB>(
        //condition: (pre, cur) => pre.isInit != cur.isInit,
        builder: (context, localdb) => _buildBody(localdb, state),
      );
    });
  }

  Widget _buildBody(LocalDB localdb, SpotifyService state) {
    if (localdb != null && localdb.isInit) {
      return FutureBuilder(
        future: localdb.suggestions(state.mySpotifyUserId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Suggestion> list = snapshot.data;
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
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Suggestions'),
                centerTitle: true,
              ),
              body: ErrorScreen(
                safeArea: true,
                title: 'Error while loading your suggestions.',
                stringBelow: [
                  "We couldn't connect to the local database.",
                  "Please, try again later."
                ],
              ),
            );
          }
        },
      );
    } else {
      BlocProvider.of<LocalDbBloc>(context).add(InitLocalDbEvent());
      return LoadingScreen(
        safeArea: true,
        title: 'Loading Your Suggestions',
        stringBelow: [
          'Openning the local database to get your suggestions sent by this device.'
        ],
      );
    }
  }
}
