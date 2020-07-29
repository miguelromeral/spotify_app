import 'package:flutter/material.dart';

class UpdatedFeedNotification extends Notification {}

class RefreshListNotification extends Notification {}

class OpenDrawerNotification extends Notification {}

class ChangePageNotification extends Notification {
  int index;

  ChangePageNotification({this.index});
}