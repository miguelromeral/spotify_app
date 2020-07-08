import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/gui.dart';

class ProfilePicture extends StatelessWidget {
  UserPublic user;
  double size;

  ProfilePicture({this.user, this.size});

  @override
  Widget build(BuildContext context) {
    if (user.images.isEmpty) {
      return Container(
        height: size,
        width: size,
        child: CircleAvatar(
            backgroundColor: colorSemiBackground,
            child: Text(
              user.displayName[0].toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            )),
      );
    } else {
      return Container(
        height: size,
        width: size,
        child: CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              placeholder: (context, url) => SpinKitDoubleBounce(
                color: colorAccent,
                size: size,
              ),
              imageUrl: user.images[0].url,
            ),
          ),
        ),
      );
    }
  }
}
