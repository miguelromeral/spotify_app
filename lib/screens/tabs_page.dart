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

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  SpotifyBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  StreamSubscription _intentDataStreamSubscription;
  String _sharedText;

  @override
  void initState() {
    super.initState();
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (!value.contains(SpotifyService.redirectUri)) {
        setState(() {
          _sharedText = value;
        });
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    if (_bloc != null) {
      _bloc.state.dispose();
    }
    super.dispose();
  }

  Future openIntent(String intent, SpotifyService state) async {
    try {
      print("Intent: " + intent);
      Uri uri = Uri.parse(intent);
      String type = uri.pathSegments[0];
      String id = uri.pathSegments[1];
      if (type != "track") throw Exception("Only tracks available to share");

      Track track = await state.api.tracks.get(id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShareTrack(track: track)),
      );
    } catch (e) {
      print("Error while extracting song: $e.");
    }
    setState(() => _sharedText = null);
    print("End Intent");
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      if (_sharedText != null) {
        openIntent(_sharedText, state);
        return Scaffold(
          body: Center(child: Text("Retrieving intent...")),
        );
      } else {
        return _fullTree(state);
      }
    });
  }

  Widget _fullTree(SpotifyService state) {
    return NotificationListener<OpenDrawerNotification>(
      onNotification: (notification) {
        _scaffoldKey.currentState.openDrawer();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(context: context),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            for (final tabItem in TabNavigationItem.items(state)) tabItem.page,
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
              for (final tabItem in TabNavigationItem.items(state))
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