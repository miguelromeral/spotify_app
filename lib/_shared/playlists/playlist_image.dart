import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class PlaylistImage extends StatelessWidget {
  PlaylistSimple playlist;
  double size;

  PlaylistImage({this.playlist, this.size});

  @override
  Widget build(BuildContext context) {
    if (playlist != null && playlist.images.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: playlist.images[0].url,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:  CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: 'https://e7.pngegg.com/pngimages/158/639/png-clipart-spotify-streaming-media-logo-playlist-spotify-app-icon-logo-music-download.png',
        ),
      );
    }
  }
}
