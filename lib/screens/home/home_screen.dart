import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/_shared/custom_appbar.dart';
import 'package:spotify_app/screens/home/feed_list.dart';
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
        return Scaffold(
          appBar: CustomAppBar(
            title: "My Friends Suggestions",
          ),
          body: Center(
            child: FeedList(),
          ),
        );
      },
    );
  }
}
