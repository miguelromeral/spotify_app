import 'package:ShareTheMusic/_shared/tracks/track_duration.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/screens/styles.dart';

class AlbumPicture extends StatefulWidget {
  final Track track;
  final double size;
  final bool showDuration;

  AlbumPicture({this.showDuration, this.track, this.size});

  @override
  _AlbumPictureState createState() => _AlbumPictureState();
}

class _AlbumPictureState extends State<AlbumPicture>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.track.id != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _buildAlbum(),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.music_note),
      );
    }
  }

  Widget _buildAlbum() {
    if (widget.showDuration != null && widget.showDuration) {
      return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
        _getWidgetAlbum(),
        TrackDuration(duration: widget.track.durationMs),
      ]);
    } else {
      return _getWidgetAlbum();
    }
  }

  Widget _getWidgetAlbum() {
    return CachedNetworkImage(
      placeholder: (context, url) => SpinKitCubeGrid(
        color: colorAccent,
        duration: Duration(seconds: 1),
        size: widget.size - 20,
      ),
      imageUrl: widget.track.album.images[0].url,
    );
  }
}
