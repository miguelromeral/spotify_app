import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class ProfilePicture extends StatelessWidget {

  UserPublic user;
  double size;

  ProfilePicture({ this.user, this.size });

  @override
  Widget build(BuildContext context) {
    Widget child = null;
    if (user.images.isEmpty) {
      child = CircleAvatar(child: Text(user.displayName[0]));
    } else {
      child = CircleAvatar(
          radius: 1.0,
          backgroundImage: NetworkImage(user.images[0].url),
          backgroundColor: Colors.transparent);
    }
    return Container(
      height: size,
      width: size,
      //margin: const EdgeInsets.only(right: 4.0),
      child: child,
    );
  }
}