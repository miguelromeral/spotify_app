import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/screens/styles.dart';

class AlbumPicture extends StatefulWidget {
  final Track track;
  final double size;

  AlbumPicture({this.track, this.size});

  @override
  _AlbumPictureState createState() => _AlbumPictureState();
}

class _AlbumPictureState extends State<AlbumPicture>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        placeholder: (context, url) => SpinKitCubeGrid(
          color: colorAccent,
          duration: Duration(seconds: 1),
          size: widget.size - 20,
        ),
        imageUrl: widget.track.album.images[0].url,
      ),
    );
  }
}
