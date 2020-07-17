import 'package:ShareTheMusic/_shared/tracks/track_duration.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
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
    if (widget.track.id == null) return [];
    return [
      PopupItemOpenTrack(track: widget.track).create(),
      PopupItemUpdateSuggestion(track: widget.track).create(),
      PopupItemShare(shareContent: _getShareContent(), title: 'Share Track')
          .create(),
    ];
  }

  String _getShareContent() {
    return '${widget.track.name}, by ${widget.track.artists[0].name}';
  }

  List<Widget> _content() {
    List<Widget> list = List();
    list.add(Text(
      "${widget.track.name}",
      style: styleFeedTitle,
    ));
    list.add(SizedBox(height: 4.0));
    list.add(Text(
      "${widget.track.artists[0].name}",
      style: styleFeedTrack,
    ));
    list.add(SizedBox(height: 4.0));
    list.add(Text(
      "${widget.track.album.name}",
      style: styleFeedArtist,
    ));

    if (Settings.getValue<bool>(settings_track_popularity, true)) {
      list.add(SizedBox(height: 4.0));
      list.add(Text(
        "${widget.track.popularity}% pop.",
        style: styleFeedAgo,
      ));
    }

    return list;
  }

  Widget _leadingIcon() {
    return Container(
      height: 60.0,
      padding: EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Hero(
            tag: widget.track.hashCode.toString(),
            child: AlbumPicture(
              track: widget.track,
              size: 25.0,
            ),
          ),
          _showDurationWidget(),
        ],
      ),
    );
  }

  Widget _showDurationWidget() {
    if (Settings.getValue<bool>(settings_track_duration, true)) {
      return TrackDuration(
        duration: widget.track.durationMs,
      );
    } else {
      return Container();
    }
  }
}
