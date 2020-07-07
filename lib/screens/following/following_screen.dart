import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/_shared/custom_appbar.dart';
import 'package:spotify_app/screens/following/following_list.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return StreamProvider<List<Following>>.value(
          builder: (context, widget) {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'Follow App Users',
              ),
              body: Center(
                child: FollowingList(),
              ),
            );
          },
          value: state.db.following,
        );
      },
    );
  }

}
