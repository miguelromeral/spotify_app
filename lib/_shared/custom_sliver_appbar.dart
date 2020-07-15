import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import '../_shared/users/profile_picture.dart';
import '../services/notifications.dart';
import '../services/spotifyservice.dart';
import '../blocs/spotify_bloc.dart';
import '../blocs/spotify_events.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final SpotifyService state;

  const CustomSliverAppBar({Key key, this.title, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Container(
        padding: EdgeInsets.all(8.0),
        child: BlocBuilder<SpotifyBloc, SpotifyService>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                OpenDrawerNotification().dispatch(context);
              },
              child: _buildContent(context, state.myUser),
            );
          },
        ),
      ),
      title: Text(title),
      centerTitle: true,
      floating: true,
    );
  }

  Widget _buildContent(BuildContext context, User state) {
    if (state != null) {
      return ProfilePicture(
        user: state,
        size: 40.0,
      );
    } else {
      //return CircularProgressIndicator();
      return Icon(Icons.list);
    }
  }
}
