import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_app/models/suggestion.dart';

class SuggestionsList extends StatefulWidget {
  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  @override
  Widget build(BuildContext context) {
    final sugs = Provider.of<List<Suggestion>>(context);

    return Flexible(
      child: ListView.builder(
          itemCount: sugs.length,
          itemBuilder: (context, index) {
            var item = sugs[index];
            return ListTile(
                title: Text(item.trackid), subtitle: Text(item.fuserid));
          }),
    );
  }
}
