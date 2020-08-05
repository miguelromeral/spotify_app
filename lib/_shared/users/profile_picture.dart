import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/screens/styles.dart';

/// Shows the profile picture of an Spotify User
class ProfilePicture extends StatefulWidget {
  /// Spotify User
  final UserPublic user;

  /// Size of the widget
  final double size;

  ProfilePicture({@required this.user, this.size, Key key}) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    // If the user does not have a profile picture, set a default one
    if (widget.user.images.isEmpty) {
      return _getAvatar(Text(
        widget.user.displayName[0].toUpperCase(),
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
        ),
      ));
    } else {
      // Retrieve image from Spotify User
      return _getAvatar(
        CachedNetworkImage(
          placeholder: (context, url) =>
              /* SpinKitDoubleBounce(
                color: colorAccent,
                size: widget.size,
              ),*/
              CircularProgressIndicator(),
          imageUrl: widget.user.images[0].url,
        ),
      );
    }
  }

  /// Draws the circle container in which the photo will be placed
  Widget _getAvatar(Widget child) {
    return Container(
      height: widget.size,
      width: widget.size,
      child: CircleAvatar(
        backgroundColor: colorThirdBackground,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: child,
        ),
      ),
    );
  }
}
