import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/_shared/custom_appbar.dart';
import 'package:spotify_app/screens/home/feed_item.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class ListSuggestions extends StatefulWidget {
  List<Suggestion> suggestions;

  ListSuggestions({Key key, this.suggestions}) : super(key: key);

  @override
  _ListSuggestionsState createState() => _ListSuggestionsState();
}

class _ListSuggestionsState extends State<ListSuggestions> {
  Widget _buildList() {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return ListView.builder(
            itemCount: widget.suggestions == null ? 0 : widget.suggestions.length,
            itemBuilder: (_, index) {
              Suggestion saved = widget.suggestions[widget.suggestions.length - index - 1];
              return FutureBuilder(
                future: state.api.tracks.get(saved.trackid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FeedItem(suggestion: saved, track: snapshot.data);
                  } else {
                    return Text("No track found");
                  }
                },
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Scaffold(
          appBar: CustomAppBar(
            title: 'My Suggestions',
          ),
          body: _buildList()),
    );
  }
}
