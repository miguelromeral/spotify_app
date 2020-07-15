import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';

class PopupItemShare extends PopupItemBase {
  String shareContent;

  PopupItemShare({this.shareContent, String title})
      : super(
          icon: 'share',
          text: title,
        );

  @override
  void execute(BuildContext context) async {
    Share.share(shareContent);
  }
}
