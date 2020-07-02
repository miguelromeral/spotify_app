import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/album_picture.dart';
import 'package:spotify_app/custom_widgets/custom_appbar.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/screens/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedSongs extends StatefulWidget {
  @override
  _SavedSongsState createState() => _SavedSongsState();
}

class _SavedSongsState extends State<SavedSongs> {
  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: CustomAppBar(
        title: 'My Saved Songs',
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: state.myUser,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data;
              return FutureBuilder<Iterable<TrackSaved>>(
                future: state.api.tracks.me.saved.all(),
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TrackSaved> tracks = snapshot.data.toList();
                    return ListSongs(
                      tracks: tracks.map((e) => e.track).toList(),
                    );
                    //return Text("Tracks: ${tracks.length}");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future redirect(Uri authUri) async {
    if (await canLaunch(authUri.toString())) {
      await launch(authUri.toString());
    }
  }
}
