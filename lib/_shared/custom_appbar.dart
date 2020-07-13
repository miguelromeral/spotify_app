import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/notifications.dart';

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

    return AppBar(
      leading: Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder<User>(
          future: state.myUser,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  OpenDrawerNotification().dispatch(context);
                },
                child: ProfilePicture(
                  user: snapshot.data,
                  size: 40.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
      title: Text(titleText),
      centerTitle: true,
    );
  }
}
