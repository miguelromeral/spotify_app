import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/album_picture.dart';
import 'package:spotify_app/custom_widgets/card_info.dart';
import 'package:spotify_app/custom_widgets/custom_appbar.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/screens/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: CustomAppBar(
        title: 'Feed',
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: state.myUser,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data;
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CardInfo(
                            title: 'Display Name',
                            content: user.displayName,
                          ),
                          CardInfo(
                            title: 'Email',
                            content: user.email,
                          ),
                          CardInfo(
                            title: 'Followers',
                            content: user.followers.total.toString(),
                          ),
                          CardInfo(
                            title: 'User ID',
                            content: user.id,
                          ),
                          FutureBuilder<Iterable<PlaylistSimple>>(
                              future: state.myPlaylists,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var lists = snapshot.data.toList();
                                  return CardInfo(
                                    title: 'Playlists',
                                    content: lists.length.toString(),
                                  );
                                } else {
                                  return Text('Unknown playlists');
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ProfilePicture(
                            user: user,
                            size: 100.0,
                          ),
                        ],
                      ),
                    ),
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
  }

  Future redirect(Uri authUri) async {
    if (await canLaunch(authUri.toString())) {
      await launch(authUri.toString());
    }
  }
}
