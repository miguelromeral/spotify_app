import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class AlbumPicture extends StatelessWidget {

  Track track;
  double size;

  AlbumPicture({ this.track, this.size });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => CircularProgressIndicator(),
      imageUrl: track.album.images[0].url,
    );
  }
}