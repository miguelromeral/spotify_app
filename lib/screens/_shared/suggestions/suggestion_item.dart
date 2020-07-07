import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/popup_item.dart';
import 'package:spotify_app/screens/_shared/tracks/album_picture.dart';
import 'package:spotify_app/screens/_shared/users/profile_picture.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  value.listen();
                  break;
                case PopupActionType.vote:
                  _vote(context, BlocProvider.of<SpotifyBloc>(context).state,
                      value.suggestion, value.track);
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

  Widget _createLeadingIcon(UserPublic user, Track track) {
    if (user != null) {
      return Stack(
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
        ],
      );
    } else {
      return Stack(
        fit: StackFit.loose,
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            //color: Colors.red,
            child: AlbumPicture(
              track: track,
              size: 50.0,
            ),
          ),
        ],
      );
    }
  }

  Widget _createTitle(Track track, UserPublic user) {
    if (user != null) {
      return Text(user.displayName);
    } else {
      return Text(track.name);
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

  String _getLikes(Suggestion suggestion){
    return suggestion.likes == null ? '' : 'Likes: ${suggestion.likes.toString()}';
  }

  Widget _createTile(Track track, UserPublic user, Suggestion suggestion) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return ListTile(
          leading: _createLeadingIcon(user, track),
          trailing: IconButton(
            onPressed: () {
              dynamic tmp = _menuKey.currentState;
              tmp.showButtonMenu();
            },
            icon: Icon(Icons.more_vert),
          ),
          title: _createTitle(track, user),
          subtitle: _createDescription(suggestion, track, user),
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
