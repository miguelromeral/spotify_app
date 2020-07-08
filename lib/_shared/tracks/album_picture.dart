import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/screens/styles.dart';

class AlbumPicture extends StatefulWidget {
  Track track;
  double size;

  AlbumPicture({this.track, this.size});

  @override
  _AlbumPictureState createState() => _AlbumPictureState();
}

class _AlbumPictureState extends State<AlbumPicture>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      // Los dos puntos hacen referencia a la anterior variable asignada, en este caso "animation"
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        placeholder: (context, url) => //CircularProgressIndicator(),
        
        SpinKitCubeGrid(
          color: colorAccent,
          size: 50.0,
        ), 
        imageUrl: widget.track.album.images[0].url,
      ),
    );
  }
}
