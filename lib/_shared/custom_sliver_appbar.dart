import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final SpotifyService state;

  const CustomSliverAppBar({Key key, this.title, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
      title: Text(title),
      centerTitle: true,
      //expandedHeight: 200.0,
      floating: true,
      //snap: true,
      /*flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
        ),
      ),*/
    );
  }
}
