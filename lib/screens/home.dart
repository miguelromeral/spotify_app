import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/material_utilities.dart';
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
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
            title: Row(
              children: [
                FutureBuilder<User>(
                  future: state.myUser,
                  initialData: null,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      User user = snapshot.data;
                      return GUI.getProfilePicture(user, 50.0);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
                Text('Spotify App!'),
              ],
            ),
          ),
          body: Center(
            child: FutureBuilder<User>(
              future: state.myUser,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data;
                  return Column(
                    children: [
                      GUI.getProfilePicture(user, 100.0),
                      Text(user.displayName),
                      Text(user.email),
                      Text(user.followers.total.toString()),
                      Text(user.id),
                      FutureBuilder<Iterable<TrackSaved>>(
                        future: state.api.tracks.me.saved.all(),
                        initialData: null,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<TrackSaved> tracks = snapshot.data.toList();
                            return Flexible(
                              child: ListView.builder(
                                  itemCount: tracks.length,
                                  itemBuilder: (_, index) {
                                    TrackSaved saved = tracks[index];
                                    return ListTile(
                                      leading: GUI.getAlbumPic(saved.track, 30.0),
                                      title: Text(saved.track.name),
                                      subtitle: Text(saved.track.artists[0].name),
                                      //trailing: icon,
                                      //isThreeLine: true,
                                      // Interactividad:
                                      onTap: () {},
                                      //onLongPress: () => _pressCallback,
                                      //enabled: false,
                                      //selected: true,
                                    );
                                  }),
                            );
                            //return Text("Tracks: ${tracks.length}");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
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
      },
    );
  }

  Future redirect(Uri authUri) async {
    if (await canLaunch(authUri.toString())) {
      await launch(authUri.toString());
    }
  }
}
