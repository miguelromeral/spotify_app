import 'package:ShareTheMusic/services/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spotify/spotify.dart';

/// Playlist Picture Widget
class PlaylistImage extends StatelessWidget {
  /// Playlist to show the image
  final PlaylistSimple playlist;

  PlaylistImage({@required this.playlist});

  @override
  Widget build(BuildContext context) {
    // Only show the image if there's something to show
    if (playlist != null && playlist.images.isNotEmpty) {
      // Make them a little bit rounded.
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          // Animation when loading.
          placeholder: (context, url) => SpinKitCubeGrid(
            color: colorAccent,
            duration: Duration(milliseconds: 500),
          ),
          imageUrl: playlist.images[0].url,
        ),
      );
    } else {
      // Default icon for playlists
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            color: colorThirdBackground, child: Icon(Icons.library_music)),
      );
    }
  }
}
