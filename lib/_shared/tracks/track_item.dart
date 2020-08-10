import 'package:ShareTheMusic/_shared/explicit_badge.dart';
import 'package:ShareTheMusic/_shared/tracks/track_duration.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/share_track/share_track.dart';
import 'package:ShareTheMusic/services/spotify_stats.dart';
import 'package:ShareTheMusic/services/styles.dart';
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

/// Shows a track in a list of tracks, like a list tile
class TrackItem extends StatefulWidget {
  /// Track to show
  final Track track;

  const TrackItem({
    Key key,
    @required this.track,
  }) : super(key: key);

  @override
  _TrackItemState createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        // When touched the tile, open the share track screen
        return GestureDetector(
          onTap: () {
            try {
              navigate(context, ShareTrack(track: widget.track));
            } catch (err) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Couldn't open the track.")));
            }
          },
          child: Container(
            color: Colors.transparent,
            child: CustomListTile(
              key: Key(widget.track.id),
              // Left icon
              leadingIcon: _leadingIcon(),
              // Content
              content: _content(),
              // Menu items
              menuItems: _getActions(),
            ),
          ),
        );
      },
    );
  }

  /// Gives the menu options in for this element
  List<PopupMenuItem<PopupItemBase>> _getActions() {
    // If the track is not in Spotify (local file), no options
    if (widget.track.id == null) return [];
    return [
      PopupItemOpenTrack(track: widget.track).create(),
      PopupItemUpdateSuggestion(track: widget.track).create(),
      PopupItemShare(
              shareContent:
                  '${widget.track.name}, by ${widget.track.artists[0].name}',
              title: 'Share Track')
          .create(),
    ];
  }

  /// Text to show in the tile info
  List<Widget> _content() {
    List<Widget> list = List();

    // Track name
    list.add(Text(
      "${widget.track.name}",
      style: styleFeedTitle,
    ));
    list.add(SizedBox(height: 4.0));

    // Artists of the track
    list.add(Text(
      "${getArtists(widget.track)}",
      style: styleFeedTrack,
    ));
    list.add(SizedBox(height: 4.0));

    // Album name
    list.add(Text(
      "${widget.track.album.name}",
      style: styleFeedArtist,
    ));

    // Popularity of the track (if settings specified)
    if (Settings.getValue<bool>(settingsTrackPopularity, true)) {
      list.add(SizedBox(height: 4.0));
      list.add(Text(
        "${widget.track.popularity}% pop.",
        style: styleFeedAgo,
      ));
    }

    // Explicit badge if the track is so
    if (widget.track.explicit) {
      list.add(SizedBox(height: 4.0));
      list.add(ExplicitBadge());
    }

    return list;
  }

  /// Creates the track icon at the left
  Widget _leadingIcon() {
    return Container(
      height: 60.0,
      padding: EdgeInsets.all(8.0),
      // We place here a stack so as to not have problems with the hero animation
      // Despite the album picture widget already has code to implement the duration,
      // if we put it there, while the animation is being ran, the duration widget
      // won't be visible and the user could see it, so instead, place it here.
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

  /// Creates the duration of the track widget if settings required
  Widget _showDurationWidget() {
    if (Settings.getValue<bool>(settingsTrackDuration, true)) {
      return TrackDuration(
        duration: widget.track.durationMs,
      );
    } else {
      return Container();
    }
  }
}
