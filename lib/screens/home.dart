import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/album_picture.dart';
import 'package:spotify_app/custom_widgets/custom_appbar.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/custom_widgets/suggestions_list.dart';
import 'package:spotify_app/screens/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return Scaffold(
      appBar: CustomAppBar(title: 'Feed',),
      body: Center(
        child: SuggestionsList(),
      ),
    );
  }
}
