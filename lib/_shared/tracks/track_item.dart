import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/custom_listtile.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_track.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_share.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_update_suggestion.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import 'album_picture.dart';

class TrackItem extends StatefulWidget {
  const TrackItem({
    Key key,
    @required this.track,
  }) : super(key: key);

  final Track track;

  @override
  _TrackItemState createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return CustomListTile(
          key: Key(widget.track.id),
          leadingIcon: _leadingIcon(),
          content: _content(),
          menuItems: _getActions(),
        );
      },
    );
  }

  List<PopupMenuItem<PopupItemBase>> _getActions() {
    return [
      PopupItemOpenTrack(track: widget.track).create(),
      PopupItemUpdateSuggestion(track: widget.track).create(),
      PopupItemShare(shareContent: _getShareContent(), title: 'Share Track').create(),
    ];
  }

  String _getShareContent(){
    return '${widget.track.name}, by ${widget.track.artists[0].name}';
  }

  List<Widget> _content() {
    return [
      Text(
        "${widget.track.name}",
        style: styleFeedTitle,
      ),
      SizedBox(height: 4.0),
      Text(
        "${widget.track.artists[0].name}",
        style: styleFeedTrack,
      ),
      SizedBox(height: 4.0),
      Text(
        "${widget.track.album.name}",
        style: styleFeedArtist,
      )
    ];
  }

  Widget _leadingIcon() {
    return Container(
      height: 60.0,
      padding: EdgeInsets.all(8.0),
      child: Hero(
        tag: widget.track.hashCode.toString(),
        child: AlbumPicture(
          track: widget.track,
          size: 25.0,
        ),
      ),
    );
  }
}
