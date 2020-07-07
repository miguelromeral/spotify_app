import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/mysuggestions/suggestions_list.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class MySuggestionsScreen extends StatefulWidget {
  @override
  _MySuggestionsScreenState createState() => _MySuggestionsScreenState();
}

class _MySuggestionsScreenState extends State<MySuggestionsScreen> {
  List<Suggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      if (state.localDB != null) {
        return FutureBuilder(
          future: state.localDB.suggestions(state.db.spotifyUserID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Suggestion> list = snapshot.data;
              return SuggestionsList(
                suggestions: list,
              );
            } else {
              return Text("Error");
            }
          },
        );
      } else {
        return Text("No Local DB");
      }
    });
  }
}
