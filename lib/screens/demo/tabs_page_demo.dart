import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/mydrawer.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/tab_navigation_item.dart';
import 'package:ShareTheMusic/screens/share_track/share_track.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class TabsPageDemo extends StatefulWidget {
  @override
  _TabsPageDemoState createState() => _TabsPageDemoState();
}

class _TabsPageDemoState extends State<TabsPageDemo> {
  SpotifyBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  @override
  void dispose() {
    if (_bloc != null) {
      _bloc.state.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return _fullTree(state);
    });
  }

  Widget _fullTree(SpotifyService state) {
    var items = TabNavigationItem.itemsDemo(state);
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in items) tabItem.page,
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: colorSemiBackground,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color: Colors
                        .yellow))), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          fixedColor: colorAccent,
          unselectedItemColor: colorPrimary,
          currentIndex: _currentIndex,
          onTap: (int index) => setState(() => _currentIndex = index),
          items: [
            for (final tabItem in items)
              BottomNavigationBarItem(
                icon: tabItem.icon,
                title: tabItem.title,
              )
          ],
        ),
      ),
    );
  }
}