import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/_shared/card_info.dart';
import 'package:spotify_app/_shared/custom_appbar.dart';
import 'package:spotify_app/_shared/suggestions/suggestion_item.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: CustomAppBar(
        title: 'My Profile',
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
                          BlocBuilder<SpotifyBloc, SpotifyService>(
                            builder: (context, state) {
                              return StreamBuilder(
                                stream: state.mySuggestion,
                                builder: (context, snp) {
                                  if (snp.hasData) {
                                    Suggestion sug = snp.data;
                                    return FutureBuilder(
                                      future: state.api.tracks.get(sug.trackid),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return SuggestionItem(
                                            suggestion: sug,
                                            track: snapshot.data,
                                          );
                                        } else {
                                          return Text('Unknown Song');
                                        }
                                      },
                                    );
                                  } else {
                                    BlocProvider.of<SpotifyBloc>(context)
                                        .add(UpdateMySuggestion());
                                    return Text('Unknown Suggestion');
                                  }
                                },
                              );
                            },
                          ),
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
