import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/custom_card.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/_shared/card_info.dart';
import 'package:spotify_app/_shared/custom_appbar.dart';
import 'package:spotify_app/_shared/suggestions/suggestion_item.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'My Profile',
      ),
      body: BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
        return Center(
          child: FutureBuilder<User>(
            future: state.myUser,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
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
                                  title: 'Spotify Users Followers',
                                  content: user.followers.total.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomCard(
                              content: [
                                StreamBuilder(
                                  stream: state.saved,
                                  builder: (context, snp) {
                                    if (snp.hasData) {
                                      return CardInfo(
                                        title: 'Saved Songs',
                                        content: snp.data.length.toString(),
                                      );
                                    } else {
                                      BlocProvider.of<SpotifyBloc>(context)
                                          .add(UpdateSaved());
                                      return Text('Unknown Saveds');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.0,),
                          Expanded(
                            flex: 1,
                            child: CustomCard(
                              content: [
                                StreamBuilder(
                                  stream: state.following,
                                  builder: (context, snp) {
                                    if (snp.hasData) {
                                      Following mine = snp.data;
                                      return CardInfo(
                                        title: 'Following',
                                        content: mine.usersList.length.toString(),
                                      );
                                    } else {
                                      return Text('Unknown Following');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.0,),
                          Expanded(
                            flex: 1,
                            child: CustomCard(
                              content: [
                                StreamBuilder(
                                  stream: state.playlists,
                                  builder: (context, snp) {
                                    if (snp.hasData) {
                                      return CardInfo(
                                        title: 'Playlists',
                                        content: snp.data.length.toString(),
                                      );
                                    } else {
                                      return Text('Unknown Playlists');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomCard(content: [
                      Text(
                        'My Last Suggestion',
                        style: styleCardHeader,
                      ),
                      StreamBuilder(
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
                      ),
                    ]),
                    /*
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.red,
                        //margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
                        padding: EdgeInsets.all(4.0),
                        child: Expanded(
                          child: Text(
                            'My Last Suggestion',
                            style: styleCardHeader,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        );
      }),
    );
  }

  Future redirect(Uri authUri) async {
    if (await canLaunch(authUri.toString())) {
      await launch(authUri.toString());
    }
  }
}
