import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class UpdatedFeedNotification extends Notification {}

class RefreshListNotification extends Notification {}

class OpenDrawerNotification extends Notification {}

class ChangePageNotification extends Notification {
  int index;

  ChangePageNotification({this.index});
}

class UpdateStatsPlaylistNotification extends Notification {
  List<PlaylistSimple> list;

  UpdateStatsPlaylistNotification({this.list});
}