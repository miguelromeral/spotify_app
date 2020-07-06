import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/_shared/album_picture.dart';
import 'package:spotify_app/screens/mysuggestion_item.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';

class ListSuggestions extends StatefulWidget {
  List<Suggestion> suggestions;

  ListSuggestions({Key key, this.suggestions}) : super(key: key);

  @override
  _ListSuggestionsState createState() => _ListSuggestionsState();
}

class _ListSuggestionsState extends State<ListSuggestions> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle; // = new Text('${widget.title}');
  BuildContext _context;

  List<Suggestion> filteredList = new List();

  _ListSuggestionsState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredList = widget.suggestions;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('My Suggestions');
        filteredList = widget.suggestions;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      String text = _searchText.toLowerCase();
      List<Suggestion> tempList = new List();
      /*for (Suggestion t in filteredList) {
        bool hit = false;
        if (t.name.toLowerCase().contains(text)) {
          hit = true;
        }
        if (!hit) {
          for (var a in t.artists) {
            if (a.name.toLowerCase().contains(text)) {
              hit = true;
              break;
            }
          }
        }
        if (hit) {
          tempList.add(t);
        }
      }
      filteredList = tempList;*/
    }

    return _listBuilder();
  }

  Widget _listBuilder() {
    return ListView.builder(
        itemCount: widget.suggestions == null ? 0 : filteredList.length,
        itemBuilder: (_, index) {
          Suggestion saved = filteredList[filteredList.length - index - 1];
          return MySuggestionItem(
            suggestion: saved,
          );
        });
  }

  @override
  void initState() {
    filteredList = widget.suggestions;
    _appBarTitle = new Text('My Suggestions');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Scaffold(
          appBar: AppBar(centerTitle: true, title: _appBarTitle, actions: [
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ]),
          body: _buildList()),
    );
  }
}
