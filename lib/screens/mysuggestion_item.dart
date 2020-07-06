import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/suggestion_popup_item.dart';
import 'package:spotify_app/screens/_shared/album_picture.dart';
import 'package:spotify_app/screens/_shared/profile_picture.dart';
import 'package:spotify_app/screens/home/feed_item.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:url_launcher/url_launcher.dart';

class MySuggestionItem extends StatefulWidget {
  final Suggestion suggestion;

  MySuggestionItem({this.suggestion});

  @override
  _MySuggestionItemState createState() => _MySuggestionItemState();
}

class _MySuggestionItemState extends State<MySuggestionItem> {
  final GlobalKey _menuKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return FutureBuilder(
          future: state.api.tracks.get(widget.suggestion.trackid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Track track = snapshot.data;
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
                    default:
                      break;
                  }
                },
                child: _createTile(track, widget.suggestion),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<FeedPopupAction>>[
                  _popupItem(PopupAction.listen, 'Listen in Spotify',
                      Icons.music_note, track, widget.suggestion),
                ],
              );
            } else {
              return Text("Error in ${widget.suggestion.trackid}");
            }
          },
        );
      },
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

  Widget _createTile(Track track, Suggestion suggestion) {
    String elapsed = timeago.format(suggestion.date, locale: 'en_short');
    return ListTile(
      leading: AlbumPicture(
        track: track,
        size: 50.0,
      ),
      trailing: IconButton(
        onPressed: () {
          dynamic tmp = _menuKey.currentState;
          tmp.showButtonMenu();
        },
        icon: Icon(Icons.more_vert),
      ),
      title: Text(track.name),
      subtitle: Text(
          '${track.artists[0].name}\n${suggestion.text}\n' +
              '$elapsed'),
      isThreeLine: true,
      /* onTap: () async {
                  //_vote();
                },*/
      onLongPress: () async {
        dynamic tmp = _menuKey.currentState;
        tmp.showButtonMenu();
      },
    );
  }
}
