import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/_shared/custom_appbar.dart';
import 'package:spotify_app/screens/home/feed_list.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        var bloc = BlocProvider.of<SpotifyBloc>(context);
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Feed',
          ),
          body: Center(
            child: _buildBody(bloc, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(SpotifyBloc bloc, SpotifyService state) {
    if (state.feed != null) {
      return FeedList();
    } else {
      bloc.add(UpdateFeed());
      return Text("Retreiving Stream...");
    }
  }
}
