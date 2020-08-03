import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/screens/share_track/share_track.dart';

/// Navigate to the share track screen to update your suggestion.
class PopupItemUpdateSuggestion extends PopupItemBase {
  Track track;

  PopupItemUpdateSuggestion({@required this.track})
      : super(
          icon: 'mysugs',
          text: 'Update Suggestion',
        );

  @override
  void execute(BuildContext context) async {
    navigate(context, ShareTrack(track: track));
  }
}
