import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/_shared/custom_appbar.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class SuggestionsList extends StatefulWidget {
  final List<Suggestion> suggestions;

  SuggestionsList({Key key, this.suggestions}) : super(key: key);

  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Suggestions'),
        ),
        body: BlocBuilder<SpotifyBloc, SpotifyService>(
          builder: (context, state) {
            return ListView.builder(
                itemCount:
                    widget.suggestions == null ? 0 : widget.suggestions.length,
                itemBuilder: (_, index) {
                  Suggestion sug =
                      widget.suggestions[widget.suggestions.length - index - 1];
                  return FutureBuilder(
                    future: state.api.tracks.get(sug.trackid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SuggestionItem(
                            suggestion: sug, track: snapshot.data);
                      } else {
                        return Text("No track found");
                      }
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}
