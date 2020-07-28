import 'dart:async';

import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
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
  List<TabNavigationItem> _pages = TabNavigationItem.itemsDemo();

  StreamSubscription _intentDataStreamSubscription;
  String _sharedText;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return FancyBackgroundApp(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index].page;
        },
      ),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }
    return BlocBuilder<ApiBloc, MyApi>(
      builder: (context, api) =>
          BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
        return _fullTree(state);
      }),
    );
  }

  Widget _fullTree(SpotifyService state) {
    return NotificationListener<OpenDrawerNotification>(
      onNotification: (notification) {
        _scaffoldKey.currentState.openDrawer();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: buildPageView(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: colorSemiBackground,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                      color: Colors
                          .yellow))), // sets the inactive color of the `BottomNavigationBar`

          /*child: BottomNavigationBar(
            fixedColor: colorAccent,
            unselectedItemColor: colorPrimary,
            currentIndex: _currentIndex,
            onTap: (int index) => setState(() => _currentIndex = index),
            items: [
              for (final tabItem in pages)
                BottomNavigationBarItem(
                  icon: tabItem.icon,
                  title: tabItem.title,
                )
            ],
          ),*/
          child: BottomNavigationBar(
            unselectedItemColor: colorThirdBackground,
            selectedItemColor: colorAccent,
            currentIndex: _currentIndex,
            onTap: (index) {
              bottomTapped(index);
            },
            items: [
              for (final tabItem in _pages)
                BottomNavigationBarItem(
                  icon: tabItem.icon,
                  title: tabItem.title,
                )
            ],
          ),
        ),
      ),
    );
  }
}
