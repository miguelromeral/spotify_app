import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/services/spotifyservice.dart';

import 'following_item.dart';

class SearchUserScreen extends StatefulWidget {
  final Key key;
  final String title;

  SearchUserScreen({this.key, this.title});

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List<Following> names = new List<Following>(); // names we get from API
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');
  Following myFollowing;
  SpotifyBloc _bloc;

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
        this._appBarTitle = new Text('Search Example');
        _filter.clear();
      }
    });
  }

  _SearchUserScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
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
    if (names.isNotEmpty) {
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
    } else {
      return Text('Type something.');
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
              var fol = snapshot.data;
              print("Fol: ${fol}");
              if (fol == null) return Text('fol null');
              return Scaffold(
                appBar: _buildBar(context),
                body: Container(
                  child: _buildList(fol),
                ),
                resizeToAvoidBottomPadding: false,
              );
            });
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }
}
