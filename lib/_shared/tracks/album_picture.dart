import 'package:ShareTheMusic/_shared/tracks/track_duration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/screens/styles.dart';

/// Shows the album cover
class AlbumPicture extends StatefulWidget {
  /// Track of the album
  final Track track;

  /// Size of the widget
  final double size;

  /// Show at the left bottom corner the duration of the track
  final bool showDuration;

  AlbumPicture({this.showDuration, this.track, this.size, Key key})
      : super(key: key);

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
      // If the track is not in Spotify (local files) show a default icon
      return CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.music_note),
      );
    }
  }

  /// Creates the album cover
  Widget _buildAlbum() {
    if (widget.showDuration != null && widget.showDuration) {
      // We use a stack to allow the track duration widget be over the album cover
      return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
        _getWidgetAlbum(),
        TrackDuration(duration: widget.track.durationMs),
      ]);
    } else {
      return _getWidgetAlbum();
    }
  }

  /// Gives us the actual image of the cover
  Widget _getWidgetAlbum() {
    return CachedNetworkImage(
      // If loading, show an animation
      placeholder: (context, url) => SpinKitCubeGrid(
        color: colorAccent,
        duration: Duration(seconds: 1),
        size: widget.size - 20,
      ),
      // URL of the album cover
      imageUrl: widget.track.album.images[0].url,
    );
  }
}
