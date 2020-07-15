import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import 'following_item.dart';

class SearchUserScreen extends StatefulWidget {
  final Key key;

  SearchUserScreen({this.key});

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List<Following> names = new List<Following>(); // names we get from API
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text(title);
  Following myFollowing;
  SpotifyBloc _bloc;
  static String title = 'Search Users by Name';

  void _getNames(String query) async {
    print('Retrieving: $query');
    dynamic list = await _bloc.state.db.searchFollowing(query);

    if (list == null) {
      setState(() {
        names = List();
        print('No List Found');
      });
    } else {
      var mf = await _bloc.state.db.getMyFollowing();
      setState(() {
        myFollowing = mf;
        names = list;
        print('List retrieved: ${names.length}');
      });
    }
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
        this._appBarTitle = new Text(title);
        _filter.clear();
      }
    });
  }

  _SearchUserScreenState() {
    _filter.addListener(() {
      print("Filter Text: ${_filter.text}");
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          names = List();
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
        _getNames(_filter.text);
      }
    });
  }

  Widget _buildList(Following fol) {
    if (names.isNotEmpty && _filter.text.isNotEmpty) {
      return ListView.builder(
          itemCount: names == null ? 0 : names.length,
          itemBuilder: (BuildContext context, int index) {
            /*return new ListTile(
            title: Text('${names[index].suserid} - ${names[index].name}'),
            //onTap: () => print(filteredNames[index]['name']),
          );*/

            return FollowingItem(
              myFollowings: fol,
              suserid: names[index].suserid,
            );
          });
    } else if (_filter.text.isNotEmpty) {
      return ErrorScreen(
        title: "No users found with that criteria.",
        stringBelow: ['Please, try a different search.'],
      );
    } else {
      return Container(
        child: Center(
          child: Text("Type the user's name in the search bar."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return StreamBuilder<Following>(
            stream: state.following,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var fol = snapshot.data;
                return Scaffold(
                  appBar: _buildBar(context),
                  body: Container(
                    child: _buildList(fol),
                  ),
                  resizeToAvoidBottomPadding: false,
                );
              } else {
                _bloc.add(UpdateFeed());
                return Scaffold(
                  appBar: _buildBar(context),
                  body: LoadingScreen(),
                );
              }
            });
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: [
        new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
    );
  }
}
