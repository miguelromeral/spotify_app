import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotify_stats.dart';
import 'package:ShareTheMusic/services/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify.dart';

/// Shows in the header of a sliver app bar the stats of the list of playlists passed
class HeaderPlaylistList extends StatelessWidget {
  /// List of playlists
  final List<PlaylistSimple> list;

  /// The current user loged
  final UserPublic me;

  HeaderPlaylistList({this.list, this.me});

  @override
  Widget build(BuildContext context) {
    return (list != null && me != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                createRowData(
                    "Playlists",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(list.length)}")),
                SizedBox(
                  height: 4.0,
                ),
                createRowData(
                    "Different Owners",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(differentOwners(list))}",
                        style: TextStyle(color: colorAccent))),
                SizedBox(
                  height: 4.0,
                ),
                createRowData(
                    "🔒 Private",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(playlistsPrivate(list))}",
                        style: TextStyle(color: colorAccent))),
                SizedBox(
                  height: 4.0,
                ),
                createRowData(
                    "🔘 Collab.",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(playlistsCollab(list))}",
                        style: TextStyle(color: colorAccent))),
                SizedBox(
                  height: 4.0,
                ),
                createRowData(
                    "Created by me",
                    Text(
                        "${NumberFormat("#,###", "en_US").format(playlistsMine(list, me))}",
                        style: TextStyle(color: colorAccent))),
                SizedBox(
                  height: 4.0,
                ),
              ])
        : Container());
  }
}
