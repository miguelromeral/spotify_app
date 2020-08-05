import 'package:ShareTheMusic/_shared/explicit_badge.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_open_profile.dart';
import 'package:ShareTheMusic/_shared/showup.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
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

/// Widget that shows a suggestion in a list
class SuggestionItem extends StatefulWidget {
  /// Track of the suggestion
  final Track track;

  /// User who sent the suggestion
  final UserPublic user;

  /// Suggestion data
  final Suggestion suggestion;

  /// Hero animation for the user
  final bool heroAnimation;

  SuggestionItem(
      {this.track, this.user, this.suggestion, this.heroAnimation, Key key})
      : super(key: key);

  @override
  _SuggestionItemState createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<SuggestionItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: colorBackground.withAlpha(175),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: CustomListTile(
            key: Key(widget.suggestion.suserid),
            // Left Icon
            leadingIcon: _createLeadingIcon(widget.user, widget.track),
            // Right Icon
            trailingIcon: _createTrailingIcon(widget.user, widget.track),
            // Content
            content: _content(),
            // Bottom icons
            bottomIcons: _createBottomBar(context, state),
            // Menu items
            menuItems: _getActions(widget.track, widget.user, widget.suggestion,
                state.mySpotifyUserId, state),
          ),
        );
      },
    );
  }

  /// Set the actions in the popup menu item
  List<PopupMenuItem<PopupItemBase>> _getActions(Track track, UserPublic user,
      Suggestion suggestion, String mySpotifyUserId, SpotifyService state) {
    List<PopupMenuItem<PopupItemBase>> list = List();
    list.add(PopupItemOpenTrack(track: track).create());
    // If it's not my suggestion, show the vote action
    if (suggestion.suserid != mySpotifyUserId) {
      list.add(PopupItemVote(track: track, suggestion: suggestion, state: state)
          .create());
    }
    list.add(PopupItemShare(
            shareContent: _getShareContent(), title: 'Share Suggestion')
        .create());

    // Open the profile of the user if loged
    if (user != null && !state.demo) {
      list.add(PopupItemOpenProfile(user: user).create());
    }

    return list;
  }

  /// Text to share in the intent
  String _getShareContent() {
    if (widget.user == null) {
      return '${widget.track.name}, by ${widget.track.artists[0].name}';
    } else {
      return '${widget.user.displayName} recommends "${widget.track.name}", by ${widget.track.artists[0].name}';
    }
  }

  /// Set the icon in the left of the tile
  Widget _createLeadingIcon(UserPublic user, Track track) {
    var maxsize = albumIconSize;
    // If there's a user, show their profile picture
    if (user != null) {
      return Container(
        width: maxsize,
        height: maxsize,
        padding: EdgeInsets.all(2.0),
        // If clicked, navigate to their profile screen
        child: GestureDetector(
          onTap: () {
            navigateProfile(context, user);
          },
          child: _createHeroProfile(user, maxsize),
        ),
      );
    } else {
      // If not user provided, show at the left the album cover
      return Container(
        width: maxsize,
        height: maxsize,
        padding: EdgeInsets.all(2.0),
        child: AlbumPicture(
          key: Key(track.album.id),
          showDuration: Settings.getValue<bool>(settingsTrackDuration, true),
          track: track,
          size: maxsize,
        ),
      );
    }
  }

  Widget _createHeroProfile(UserPublic user, double maxsize) {
    if (widget.heroAnimation == null || widget.heroAnimation) {
      return Hero(
        tag: user.id,
        child: ProfilePicture(
          key: Key(user.id),
          user: user,
          size: maxsize,
        ),
      );
    } else {
      return ProfilePicture(
        key: Key(user.id),
        user: user,
        size: maxsize,
      );
    }
  }

  /// Right icon in the tile
  Widget _createTrailingIcon(UserPublic user, Track track) {
    var maxsize = albumIconSize;

    /// If there's a user, their profile will be shown at the left, so
    /// then show the album cover at the right
    if (user != null) {
      return Container(
        width: maxsize,
        height: maxsize,
        padding: EdgeInsets.all(2.0),
        child: AlbumPicture(
          showDuration: Settings.getValue<bool>(settingsTrackDuration, true),
          track: track,
          size: maxsize,
        ),
      );
    } else {
      // if the cover is already shown at the left, nothing to show at the right
      return Container();
    }
  }

  /// Content of the list tile

  List<Widget> _content() {
    return [
      Container(
        child: _getFirstTitle(),
      ),
      _getSecondTitle(),
      SizedBox(height: 4.0),
      Container(
        child: _createSubtitle(),
      ),
      (widget.track.explicit ? SizedBox(height: 4.0) : Container()),
      // Explicit badge
      (widget.track.explicit ? ExplicitBadge() : Container()),
      SizedBox(height: 4.0),
      // Message from the user
      Container(
        child: Text(
          widget.suggestion.text,
          style: styleFeedContent,
        ),
      )
    ];
  }

  /// Title of the tile
  String _createTitle(Track track, UserPublic user) {
    if (user != null) {
      return user.displayName;
    } else {
      return track.name;
    }
  }

  /// Sub content of the tile
  Widget _createSubtitle() {
    if (widget.user != null) {
      return RichText(
          text: TextSpan(style: styleFeedTrack, children: [
        TextSpan(
          text: '${widget.track.name}',
        ),
        TextSpan(
            text: ' - ${widget.track.artists[0].name}', style: styleFeedArtist),
      ]));
    } else {
      return Text('${widget.track.artists[0].name}', style: styleFeedTrack);
    }
  }

  /// Main title of the tile
  Widget _getFirstTitle() {
    if (widget.user != null) {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          style: styleFeedTitle,
          text: _createTitle(widget.track, widget.user),
        ),
        // Show the time ago
        TextSpan(
            text:
                '  (${timeago.format(widget.suggestion.date, locale: 'en_short')})',
            style: styleFeedAgo),
      ]));
    } else {
      return Text(
        _createTitle(widget.track, widget.user),
        style: styleFeedTitle,
      );
    }
  }

  /// Second title of the tile
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

  /// Bottom bar with the icons
  List<Widget> _createBottomBar(BuildContext context, SpotifyService state) {
    List<Widget> list = List();

    // If there's like counter, show it
    if (widget.suggestion.likes != null) {
      // When tapped, vote for it
      list.add(GestureDetector(
        onTap: () async {
          vote(context, state, widget.suggestion, widget.track);
        },
        child: Container(
          child: Row(
            children: [
              // Vote Icon
              MyIcon(
                  icon: 'vote',
                  size: 15.0,
                  callback: () async {
                    vote(context, state, widget.suggestion, widget.track);
                  }),
              SizedBox(
                width: 4.0,
              ),
              // Likes counter
              ShowUp(
                key: Key(
                    '${widget.suggestion.suserid}-${widget.suggestion.likes}'),
                child: Text(_likesFormatted(widget.suggestion.likes)),
                delay: 350,
              ),
            ],
          ),
        ),
      ));
      list.add(SizedBox(
        width: 8.0,
      ));
    }
    // Open in spotify icon
    list.add(Container(
      //padding: EdgeInsets.all(8.0),
      child: MyIcon(
          icon: 'spotify',
          size: 15.0,
          callback: () => openTrackSpotify(widget.track)),
    ));
    list.add(SizedBox(
      width: 8.0,
    ));

    // Share content button
    list.add(Container(
      //padding: EdgeInsets.all(8.0),
      child: MyIcon(
          icon: 'share',
          size: 15.0,
          callback: () => Share.share(_getShareContent())),
    ));

    return list;
  }

  /// Print the number of likes formatted
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
