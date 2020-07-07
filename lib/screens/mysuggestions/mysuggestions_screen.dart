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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return FutureBuilder(
        future: state.getSuggestionsBySpotifyUserID(state.db.spotifyUserID),
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
    });
  }
}
