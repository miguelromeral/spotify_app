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
        /*listener: (context, ldb) {
          print("Listening Bloc Consumer...");
          //return ldb.isInit;

          setState(() {
            localdb = ldb;
          });
        },*/
        //child: _buildBody(localdb, state),
        condition: (previous, current){
          return previous.isInit != current.isInit;
        },
        builder: (context, localdb) => _buildBody(localdb, state),
      );
    });
  }

  Widget _buildBody(LocalDB localdb, SpotifyService state) {
    print("Creating MySuggestionsScreen");
    if (localdb != null && localdb.isInit) {
      return FutureBuilder(
        future: localdb.suggestions(state.mySpotifyUserId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Suggestion> list = snapshot.data;
            return SuggestionsList(
              suggestions: list,
            );
          } else {
            return ErrorScreen(
              title: 'Error while loading your suggestions.',
              stringBelow: [
                "We couldn't connect to the local database.",
                "Please, try again later."
              ],
            );
          }
        },
      );
    } else {
      BlocProvider.of<LocalDbBloc>(context).add(InitLocalDbEvent());
      return Scaffold(body: LoadingScreen());
    }
  }
}
