import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/models/tab_navigation_item.dart';
import 'package:spotify_app/screens/share_track.dart';
import 'package:spotify_app/services/DatabaseService.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  SpotifyBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<SpotifyBloc>(context);

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      return StreamProvider<List<Suggestion>>.value(
        value: DatabaseService().suggestions,
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              for (final tabItem in TabNavigationItem.items) tabItem.page,
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) => setState(() => _currentIndex = index),
            items: [
              for (final tabItem in TabNavigationItem.items)
                BottomNavigationBarItem(
                  icon: tabItem.icon,
                  title: tabItem.title,
                )
            ],
          ),
        ),
      );
    });
  }

}
