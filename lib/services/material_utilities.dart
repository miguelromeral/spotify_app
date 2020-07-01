import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as sp;

class GUI {
  static Widget getProfilePicture(sp.User user, double size) {
    Widget child = null;
    if (user.images.isEmpty) {
      child = CircleAvatar(child: Text(user.displayName[0]));
    } else {
      child = CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(user.images[0].url),
          backgroundColor: Colors.transparent);
    }
    return Container(
      height: size,
      width: size,
      margin: const EdgeInsets.only(right: 16.0),
      child: child,
    );
  }

  static Widget getAlbumPic(sp.Track track, double size) {
    return CachedNetworkImage(
      placeholder: (context, url) => CircularProgressIndicator(),
      imageUrl: track.album.images[0].url,
    );
  }
}
