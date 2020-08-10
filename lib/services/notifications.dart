import 'package:flutter/material.dart';

/// Notification dispatched to update the feed of the user (the suggestions)
class UpdatedFeedNotification extends Notification {}

/// Notification to refresh the content of a list
class RefreshListNotification extends Notification {}

/// Notification to change the index of the current page (in the bottom app bar)
class ChangePageNotification extends Notification {
  /// Index of the page to navigate
  int index;

  ChangePageNotification({this.index});
}