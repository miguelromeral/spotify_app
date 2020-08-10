import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotify_stats.dart';
import 'package:ShareTheMusic/services/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify.dart';

/// Header with stats of the list of tracks in the sliver app bar
class HeaderTrackList extends StatelessWidget {
  /// List of tracks to show stats about
  final List<Track> list;

  HeaderTrackList({this.list});

  @override
  Widget build(BuildContext context) {
    return (list != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                createRowData(
                    "Tracks",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(list.length)}")),
                SizedBox(
                  height: 4.0,
                ),
                createRowData(
                    "Artists",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(differentArtists(list))}",
                        style: TextStyle(color: colorAccent))),
                SizedBox(
                  height: 4.0,
                ),
                createRowData(
                    "Albums",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(differentAlbums(list))}",
                        style: TextStyle(color: colorAccent))),
                SizedBox(
                  height: 4.0,
                ),
                createRowData("Duration",
                    Text("${printDuration(totalDuration(list), true)}")),
                SizedBox(
                  height: 4.0,
                ),
                (Settings.getValue<bool>(settingsTrackPopularity, true)
                    ? createRowData(
                        "Av. Popularity",
                        Text(
                          "${averagePopularity(list)} %",
                          style: TextStyle(color: Colors.grey),
                        ))
                    : Container()),
              ])
        : Container());
  }
}
