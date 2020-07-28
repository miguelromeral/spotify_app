import 'dart:async';

import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/_shared/following/following_button.dart';
import 'package:ShareTheMusic/_shared/showup.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/_shared/card_info.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class UserProfileScreen extends StatefulWidget {
  final UserPublic user;

  UserProfileScreen({this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  SpotifyBloc _bloc;
  SpotifyApi _api;
  Suggestion suggestion;
  Track track;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null || _api == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
      _api = BlocProvider.of<ApiBloc>(context).state.get();
      _getData();
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return FancyBackgroundApp(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(widget.user.displayName),
              centerTitle: true,
            ),
            body: _createBody(context, widget.user, state),
          ),
        );
      },
    );
  }

  Widget _createBody(
      BuildContext context, UserPublic user, SpotifyService state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                      StreamBuilder(
                        stream: state.following,
                        builder: (context, snp) {
                          if (snp.hasData || state.lastFollowing != null) {
                            Following mine = (snp.data ?? state.lastFollowing);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: state.getFollowers(widget.user.id),
                                  builder: (context, snp) {
                                    if (snp.hasData) {
                                      List<Following> list = snp.data;
                                      /*String text = '';
                            for(var f in list){
                              text += '${f.name},\n';
                            }*/
                                      return CardInfo(
                                        title: 'ShareTheTrack followers',
                                        content: '${list.length}',
                                        //content: text,
                                      );
                                    } else {
                                      return CardInfo(
                                        title: 'ShareTheTrack followers',
                                        content: '?',
                                      );
                                    }
                                  },
                                ),
                                FutureBuilder(
                                  future: state
                                      .getFollowingBySpotifyUserID(user.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Following userFollowing = snapshot.data;
                                      return ShowUp(
                                        delay: 350,
                                        key: Key(
                                            '${userFollowing.suserid}-${mine.containsUser(userFollowing.suserid)}'),
                                        child: FollowingButton(
                                          myFollowings: mine,
                                          user: user,
                                          userFollowing: userFollowing,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
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
          SizedBox(
            height: 8.0,
          ),
          NotificationListener<UpdatedFeedNotification>(
            onNotification: (notification) {
              _getData();
              return true;
            },
            child: _buildContent(state),
          ),
          //     ]),
        ],
      ),
    );
  }

  Widget _buildContent(SpotifyService state) {
    if (suggestion == null) {
      _getData();
      return LoadingScreen(
        title: 'Loading Suggestion...',
      );
    }

    if (track == null) {
      _getData();
      return LoadingScreen(
        title: 'Loading Track...',
      );
    }

    return SuggestionItem(
      //user: widget.user,
      suggestion: suggestion,
      track: track,
    );
  }

  Future<void> _getData() async {
    if (_bloc != null && _api != null) {
      var res = await _bloc.state.getSuggestion(widget.user.id);
      _bloc.add(UpdateFeed());
      Track tr;
      if (track == null) {
        tr = await _api.tracks.get(res.trackid);
      }
      setState(() {
        suggestion = res;
        if (tr != null) {
          track = tr;
        }
      });
    }
  }
}
