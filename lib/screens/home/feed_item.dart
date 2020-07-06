import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/_shared/album_picture.dart';
import 'package:spotify_app/screens/_shared/profile_picture.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedItem extends StatefulWidget {
  final Track track;
  final UserPublic user;
  Suggestion suggestion;

  FeedItem({this.track, this.user, this.suggestion});

  @override
  _FeedItemState createState() => _FeedItemState();
}

enum PopupAction { listen, vote }

class FeedPopupAction {
  Track track;
  Suggestion suggestion;
  PopupAction action;

  FeedPopupAction({this.track, this.suggestion, this.action});
}

class _FeedItemState extends State<FeedItem> {
  bool liked;
  final GlobalKey _menuKey = new GlobalKey();

  @override
  void initState() {
    liked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FeedPopupAction>(
      key: _menuKey,
      onSelected: (FeedPopupAction value) async {
        switch (value.action) {
          case PopupAction.listen:
            if (await canLaunch(value.track.uri)) {
              print("Opening ${value.track.uri}");
              launch(value.track.uri);
            }
            break;
          case PopupAction.vote:
            _vote(context, BlocProvider.of<SpotifyBloc>(context).state,
                value.suggestion, value.track);
            break;
        }
      },
      child: _createTile(widget.track, widget.user, widget.suggestion),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<FeedPopupAction>>[
        _popupItem(PopupAction.listen, 'Listen in Spotify', Icons.music_note,
            widget.track, widget.suggestion),
        _popupItem(PopupAction.vote, 'Vote!', Icons.thumb_up, widget.track,
            widget.suggestion),
      ],
    );
  }

  PopupMenuItem<FeedPopupAction> _popupItem(PopupAction value, String text,
      IconData icon, Track track, Suggestion suggestion) {
    return PopupMenuItem(
      value:
          FeedPopupAction(track: track, action: value, suggestion: suggestion),
      child: Row(
        children: <Widget>[
          Icon(icon),
          SizedBox(
            width: 6.0,
          ),
          Text(text),
        ],
      ),
    );
  }

  Future _vote(BuildContext context, SpotifyService state,
      Suggestion suggestion, Track track) async {
    if (state.db.firebaseUserID != suggestion.fuserid) {
      await state.db.likeSuggestion(suggestion);

      //bloc.add(UpdateFeed());
      UpdatedFeedNotification().dispatch(context);

      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('You liked "${track.name}"!')));
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
    }
  }

  Widget _createTile(Track track, UserPublic user, Suggestion suggestion) {
    String elapsed = timeago.format(suggestion.date, locale: 'en_short');
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return ListTile(
          leading: Stack(
            fit: StackFit.loose,
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                //color: Colors.red,
                child: ProfilePicture(
                  user: user,
                  size: 50.0,
                ),
              ),
              Container(
                width: 30.0,
                height: 30.0,
                //color: Colors.yellow,
                child: AlbumPicture(
                  track: track,
                  size: 20.0,
                ),
              ),
              /*Container(
                height: 20.0,
                width: 50.0,
                child: ProfilePicture(
                  user: user,
                  size: 30.0,
                ),
              ),
              Container(
                height: 20.0,
                width: 20.0,
                child: AlbumPicture(
                  track: track,
                  size: 20.0,
                ),
              ),*/
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              dynamic tmp = _menuKey.currentState;
              tmp.showButtonMenu();
            },
            icon: Icon(Icons.more_vert),
          ),
          title: Text(user.displayName),
          subtitle: Text(
              '${track.name} - ${track.artists[0].name}\n${suggestion.text}\n' +
                  '$elapsed\nLikes: ${suggestion.likes}'),
          isThreeLine: true,
          onTap: () async {
            //_vote();
          },
          onLongPress: () async {
            dynamic tmp = _menuKey.currentState;
            tmp.showButtonMenu();
          },
        );
      },
    );
/*
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                constraints: BoxConstraints(
                  maxHeight: 100.0,
                  maxWidth: 100.0,
                ),
                color: Colors.red,
                child: Center(
                  child: ProfilePicture(
                    user: user,
                    size: 60.0,
                  ),
                )),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName),
                  Text(track.name),
                  Text(track.artists[0].name),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: 50.0,
                  maxWidth: 50.0,
                ),
                color: Colors.green,
                child: AlbumPicture(
                  track: track,
                  size: 50.0,
                )),
          ),
        ],
      ),
    );*/
  }
}
