import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/screens/mysuggestions/suggestions_list.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class MySuggestionsScreen extends StatefulWidget {
  @override
  _MySuggestionsScreenState createState() => _MySuggestionsScreenState();
}

class _MySuggestionsScreenState extends State<MySuggestionsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return FutureBuilder(
        future: state.getMySuggestions(),
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
