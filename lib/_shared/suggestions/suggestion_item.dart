import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/models/popup_item.dart';
import 'package:spotify_app/_shared/tracks/album_picture.dart';
import 'package:spotify_app/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';

class SuggestionItem extends StatefulWidget {
  final Track track;
  final UserPublic user;
  Suggestion suggestion;

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
        return PopupMenuButton<PopupItem>(
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
            child: _createTile(widget.track, widget.user, widget.suggestion),
            itemBuilder: (BuildContext context) => _getActions(widget.track,
                widget.user, widget.suggestion, state.db.spotifyUserID));
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

  Widget _createDescription(
      Suggestion suggestion, Track track, UserPublic user) {
    String elapsed = timeago.format(suggestion.date, locale: 'en_short');
    if (user != null) {
      return Text(
          '${track.name} - ${track.artists[0].name}\n${suggestion.text}\n' +
              '$elapsed\n${_getLikes(suggestion)}');
    } else {
      return Text('${track.artists[0].name}\n${suggestion.text}\n' +
          '$elapsed\n${_getLikes(suggestion)}');
    }
  }

  String _getLikes(Suggestion suggestion) {
    return suggestion.likes == null
        ? ''
        : 'Likes: ${suggestion.likes.toString()}';
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
        return Container(
          key: Key(suggestion.suserid),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                //color: Colors.blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        //color: Colors.black,
                        child: _createLeadingIcon(user, track)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //color: Colors.green,
                              child: Row(
                                children: [
                                  Text(
                                    _createTitle(track, user),
                                    style: styleFeedTitle,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    "(${timeago.format(suggestion.date, locale: 'en_short')})",
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
                                suggestion.text,
                                style: styleFeedContent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: _createTrailingIcon(user, track),
                    ),
                  ],
                ),
              ),
              _createBottomBar(state, track, user, suggestion),
            ],
          ),
        );
      },
    );
  }

  Widget _createBottomBar(SpotifyService state, Track track, UserPublic user,
      Suggestion suggestion) {
    List<Widget> list = List();

    if (suggestion.likes != null) {
      list.add(Container(
        child: Row(
          children: [
            MyIcon(
              icon: 'vote.png',
              size: 20.0,
              callback: () => vote(context, state, suggestion, track),
            ),
            Text(suggestion.likes.toString()),
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
          icon: 'spotify.png',
          size: 20.0,
          callback: () => openTrackSpotify(track)),
    ));
    list.add(SizedBox(
      width: 8.0,
    ));
    list.add(Container(
      padding: EdgeInsets.all(8.0),
      child: MyIcon(
        icon: 'menu.png',
        size: 20.0,
        callback: () {
          dynamic tmp = _menuKey.currentState;
          tmp.showButtonMenu();
        },
      ),
    ));

    return Container(
      //color: Colors.blue[300],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: list,
      ),
    );
  }
}
