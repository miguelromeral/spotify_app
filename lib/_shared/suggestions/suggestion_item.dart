import 'package:ShareTheMusic/_shared/explicit_badge.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_profile.dart';
import 'package:ShareTheMusic/_shared/showup.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:share/share.dart';
import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_track.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_share.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_vote.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/_shared/tracks/album_picture.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/suggestion.dart';

import '../custom_listtile.dart';

class SuggestionItem extends StatefulWidget {
  final Track track;
  final UserPublic user;
  final Suggestion suggestion;

  SuggestionItem({this.track, this.user, this.suggestion});

  @override
  _SuggestionItemState createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<SuggestionItem> {
  bool liked;

  @override
  void initState() {
    liked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return _createTile(widget.track, widget.user, widget.suggestion);
      },
    );
  }

  List<PopupMenuItem<PopupItemBase>> _getActions(Track track, UserPublic user,
      Suggestion suggestion, String mySpotifyUserId, SpotifyService state) {
    List<PopupMenuItem<PopupItemBase>> list = List();

    list.add(PopupItemOpenTrack(track: track).create());
    if (suggestion.suserid != mySpotifyUserId) {
      list.add(PopupItemVote(track: track, suggestion: suggestion, state: state)
          .create());
    }
    list.add(PopupItemShare(
            shareContent: _getShareContent(), title: 'Share Suggestion')
        .create());

    if (user != null && !state.demo) {
      list.add(PopupItemOpenProfile(user: user).create());
    }

    return list;
  }

  String _getShareContent() {
    if (widget.user == null) {
      return '${widget.track.name}, by ${widget.track.artists[0].name}';
    } else {
      return '${widget.user.displayName} recommends "${widget.track.name}", by ${widget.track.artists[0].name}';
    }
  }

  Widget _createLeadingIcon(UserPublic user, Track track) {
    var maxsize = albumIconSize;
    if (user != null) {
      return Container(
        width: maxsize,
        height: maxsize,
        padding: EdgeInsets.all(8.0),
        //color: Colors.red,
        child: ProfilePicture(
          user: user,
          size: maxsize,
        ),
      );
    } else {
      return Container(
        width: maxsize,
        height: maxsize,
        padding: EdgeInsets.all(8.0),
        //color: Colors.red,
        child: AlbumPicture(
          showDuration: Settings.getValue<bool>(settings_track_duration, true),
          track: track,
          size: maxsize,
        ),
      );
    }
  }

  Widget _createTrailingIcon(UserPublic user, Track track) {
    var maxsize = albumIconSize;
    if (user != null) {
      return Container(
        width: maxsize,
        height: maxsize,
        padding: EdgeInsets.all(8.0),
        //color: Colors.red,
        child: AlbumPicture(
          showDuration: Settings.getValue<bool>(settings_track_duration, true),
          track: track,
          size: maxsize,
        ),
      );
    } else {
      return Container();
    }
  }

  String _createTitle(Track track, UserPublic user) {
    if (user != null) {
      return user.displayName;
    } else {
      return track.name;
    }
  }

  Widget _createSubtitle() {
    if (widget.user != null) {
      return RichText(
          text: TextSpan(
              // set the default style for the children TextSpans
              style: styleFeedTrack,
              children: [
            TextSpan(
              text: '${widget.track.name}',
            ),
            TextSpan(
                text: ' - ${widget.track.artists[0].name}',
                style: styleFeedArtist),
          ]));
    } else {
      return Text('${widget.track.artists[0].name}', style: styleFeedTrack);
    }
  }

  Widget _createTile(Track track, UserPublic user, Suggestion suggestion) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return CustomListTile(
          key: Key(suggestion.suserid),
          leadingIcon: _createLeadingIcon(user, track),
          trailingIcon: _createTrailingIcon(user, track),
          content: _content(),
          bottomIcons: _createBottomBar(context, state),
          menuItems: _getActions(widget.track, widget.user, widget.suggestion,
              state.mySpotifyUserId, state),
        );
      },
    );
  }

  List<Widget> _content() {
    return [
      Container(
        //color: Colors.green,
        child: _getFirstTitle(),
      ),
      _getSecondTitle(),
      SizedBox(height: 4.0),
      Container(
        //color: Colors.yellow[100],
        child: _createSubtitle(),
      ),
      (widget.track.explicit ? SizedBox(height: 4.0) : Container()),
      (widget.track.explicit ? ExplicitBadge() : Container()),
      SizedBox(height: 4.0),
      Container(
        //color: Colors.yellow[200],
        child: Text(
          widget.suggestion.text,
          style: styleFeedContent,
        ),
      )
    ];
  }

  Widget _getFirstTitle() {
    if (widget.user != null) {
      return Row(
        children: [
          Text(
            _createTitle(widget.track, widget.user),
            style: styleFeedTitle,
          ),
          SizedBox(width: 8.0),
          Text(
            "(${timeago.format(widget.suggestion.date, locale: 'en_short')})",
            style: styleFeedAgo,
          ),
        ],
      );
    } else {
      return Text(
        _createTitle(widget.track, widget.user),
        style: styleFeedTitle,
      );
    }
  }

  Widget _getSecondTitle() {
    if (widget.user != null) {
      return Container();
    } else {
      return Text(
        "(${timeago.format(widget.suggestion.date, locale: 'en_short')})",
        style: styleFeedAgo,
      );
    }
  }

  List<Widget> _createBottomBar(BuildContext context, SpotifyService state) {
    List<Widget> list = List();

    if (widget.suggestion.likes != null) {
      list.add(Container(
        child: Row(
          children: [
            MyIcon(
                icon: 'vote',
                size: 20.0,
                callback: () async {
                  if (state.demo) {
                    showMyDialog(context, "You can't Vote Songs in DEMO",
                        "Please, log in with Spotify if you want to vote for this song.");
                  } else {
                    vote(context, state, widget.suggestion, widget.track);
                  }
                }),
            SizedBox(
              width: 4.0,
            ),
            ShowUp(
              key: Key(
                  '${widget.suggestion.suserid}-${widget.suggestion.likes}'),
              child: Text(_likesFormatted(widget.suggestion.likes)),
              delay: 350,
            ),
          ],
        ),
      ));
      list.add(SizedBox(
        width: 8.0,
      ));
    }

    list.add(Container(
      padding: EdgeInsets.all(8.0),
      child: MyIcon(
          icon: 'spotify',
          size: 20.0,
          callback: () => openTrackSpotify(widget.track)),
    ));
    list.add(SizedBox(
      width: 8.0,
    ));

    list.add(Container(
      padding: EdgeInsets.all(8.0),
      child: MyIcon(
          icon: 'share',
          size: 20.0,
          callback: () => Share.share(_getShareContent())),
    ));

    return list;
  }

  String _likesFormatted(int likes) {
    if (likes >= 1000000) {
      int miles = (likes / 1000000).truncate();
      int dec = ((likes / 100000).truncate() % 10);
      return '$miles,$dec M';
    } else if (likes >= 1000) {
      int miles = (likes / 1000).truncate();
      int dec = ((likes / 100).truncate() % 10);
      return '$miles,$dec K';
    } else if (likes == 0) {
      return '';
    } else {
      return likes.toString();
    }
  }
}
