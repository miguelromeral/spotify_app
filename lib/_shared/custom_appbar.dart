import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import '../services/spotifyservice.dart';
import '../blocs/spotify_events.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final String titleText;

  CustomAppBar({this.titleText});

  @override
  final Size preferredSize = Size.fromHeight(60.0);
  @override
  final double elevation = 0.0;

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    if (state.demo) {
      return AppBar(
        title: Text(titleText),
        centerTitle: true,
      );
    } else {
      return AppBar(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          child: BlocBuilder<SpotifyBloc, SpotifyService>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  OpenDrawerNotification().dispatch(context);
                },
                child: _buildContent(state, context),
              );
            },
          ),
        ),
        title: Text(titleText),
        centerTitle: true,
      );
    }
  }

  Widget _buildContent(SpotifyService state, BuildContext context) {
    if (state.myUser != null) {
      return ProfilePicture(
        user: state.myUser,
        size: 40.0,
      );
    } else {
      //return CircularProgressIndicator();
      return Icon(Icons.list);
    }
  }
}
