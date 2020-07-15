import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/custom_card.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/_shared/card_info.dart';
import 'package:ShareTheMusic/_shared/custom_appbar.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulWidget {
  final UserPublic user;

  UserProfileScreen({this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.user.displayName),
            centerTitle: true,
          ),
          body: _createBody(context, widget.user, state),
        );
      },
    );
  }

  Widget _createBody(
      BuildContext context, UserPublic user, SpotifyService state) {
    return Center(
      child: Column(
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
                        title: 'Spotify ID',
                        content: user.id,
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
          /*CustomCard(content: [
            Text(
              'My Last Suggestion',
              style: styleCardHeader,
            ),*/
          Text('My Last Suggestion'),
          SizedBox(height: 8.0,),
          FutureBuilder(
            future: state.getSuggestion(widget.user.id),
            builder: (context, snp) {
              if (snp.hasData) {
                Suggestion sug = snp.data;
                return FutureBuilder(
                  future: state.api.tracks.get(sug.trackid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SuggestionItem(
                        //user: widget.user,
                        suggestion: sug,
                        track: snapshot.data,
                      );
                    } else {
                      return Text('Unknown Song');
                    }
                  },
                );
              } else {
                BlocProvider.of<SpotifyBloc>(context).add(UpdateMySuggestion());
                return Text('Unknown Suggestion');
              }
            },
          ),
          //     ]),
        ],
      ),
    );
  }
}
