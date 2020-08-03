import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';

/// Share text content via intent
class PopupItemShare extends PopupItemBase {
  String shareContent;

  PopupItemShare({@required this.shareContent, String title})
      : super(
          icon: 'share',
          // Title to show in the popup
          text: title,
        );

  @override
  void execute(BuildContext context) async {
    Share.share(shareContent);
  }
}