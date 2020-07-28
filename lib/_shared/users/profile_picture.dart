import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/screens/styles.dart';

class ProfilePicture extends StatefulWidget {
  final UserPublic user;
  final double size;
  final key;

  ProfilePicture({@required this.user, this.size, this.key}) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    if (widget.user.images.isEmpty) {
      return Container(
        height: widget.size,
        width: widget.size,
        child: CircleAvatar(
            backgroundColor: colorThirdBackground,
            child: Text(
              widget.user.displayName[0].toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            )),
      );
    } else {
      return Container(
        height: widget.size,
        width: widget.size,
        child: CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              placeholder: (context, url) => /* SpinKitDoubleBounce(
                color: colorAccent,
                size: widget.size,
              ),*/
              CircularProgressIndicator(),
              imageUrl: widget.user.images[0].url,
            ),
          ),
        ),
      );
    }
  }
}
