import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/_shared/popup/popup_item.dart';
import 'package:spotify_app/_shared/tracks/album_picture.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';

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
  final GlobalKey _menuKey = new GlobalKey();

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

  List<PopupMenuItem<PopupItem>> _getActions(Track track, UserPublic user,
      Suggestion suggestion, String mySpotifyUserId) {
    List<PopupMenuItem<PopupItem>> list = List();

    list.add(PopupItem.createListenOption(track));
    if (suggestion.suserid != mySpotifyUserId) {
      list.add(PopupItem.createVoteOption(track, suggestion));
    }
    return list;
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
          track: track,
          size: maxsize,
        ),
      );
    } else {
      return null;
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
          bottomIcons: _createBottomBar(state),
          menuItems: _getActions(widget.track, widget.user, widget.suggestion,
              state.db.spotifyUserID),
        );
      },
    );
  }

  List<Widget> _content() {
    return [
      Container(
        //color: Colors.green,
        child: Row(
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
        ),
      ),
      SizedBox(height: 4.0),
      Container(
        //color: Colors.yellow[100],
        child: _createSubtitle(),
      ),
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

  List<Widget> _createBottomBar(SpotifyService state) {
    List<Widget> list = List();

    if (widget.suggestion.likes != null) {
      list.add(Container(
        child: Row(
          children: [
            MyIcon(
              icon: 'vote',
              size: 20.0,
              callback: () =>
                  vote(context, state, widget.suggestion, widget.track),
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(widget.suggestion.likes.toString()),
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
    /*  list.add(PopupMenuButton<PopupItem>(
        key: _menuKey,
        onSelected: (PopupItem value) async {
          switch (value.action) {
            case PopupActionType.listen:
              openTrackSpotify(widget.track);
              break;
            case PopupActionType.vote:
              vote(context, BlocProvider.of<SpotifyBloc>(context).state,
                  widget.suggestion, widget.track);
              break;
            default:
              break;
          }
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: MyIcon(
            icon: 'menu',
            size: 20.0,
            callback: () {
              dynamic tmp = _menuKey.currentState;
              tmp.showButtonMenu();
            },
          ),
        ),
        itemBuilder: (BuildContext context) => _getActions(widget.track,
            widget.user, widget.suggestion, state.db.spotifyUserID)));
*/
    return list;
/*    return Container(
      //color: Colors.blue[300],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: list,
      ),
    );*/
  }
}
