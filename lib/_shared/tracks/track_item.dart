import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/models/popup_item.dart';
import 'package:spotify_app/screens/share_track/share_track.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

import 'album_picture.dart';

class TrackItem extends StatefulWidget {
  const TrackItem({
    Key key,
    @required this.track,
  }) : super(key: key);

  final Track track;

  @override
  _TrackItemState createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  final GlobalKey _menuKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return _createItem(context);
      },
    );
  }

  List<PopupMenuItem<PopupItem>> _getActions() {
    List<PopupMenuItem<PopupItem>> list = List();

    list.add(PopupItem.createListenOption(widget.track));
    list.add(PopupItem.createSuggestionOption(widget.track));

    return list;
  }

  Widget _createItem(BuildContext context) {
    return Container(
      //color: Colors.red,
      child: Row(
        children: [
          Container(
            height: 75.0,
            padding: EdgeInsets.all(8.0),
            child: Hero(
              tag: widget.track.hashCode.toString(),
              child: AlbumPicture(
                track: widget.track,
                size: 25.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(8.0),
                //color: Colors.yellow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.track.name}",
                      style: styleFeedTitle,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "${widget.track.artists[0].name}",
                      style: styleFeedTrack,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "${widget.track.album.name}",
                      style: styleFeedArtist,
                    ),
                  ],
                )),
          ),
          Container(
              child: PopupMenuButton<PopupItem>(
                  key: _menuKey,
                  onSelected: (PopupItem value) async {
                    switch (value.action) {
                      case PopupActionType.listen:
                        openTrackSpotify(widget.track);
                        break;
                      case PopupActionType.tosuggestion:
                        value.updateSuggestion(context);
                        break;
                      default:
                        break;
                    }
                  },
                  child: IconButton(
                    onPressed: () {
                      dynamic tmp = _menuKey.currentState;
                      tmp.showButtonMenu();
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                  itemBuilder: (BuildContext context) => _getActions())),
        ],
      ),
    );

    /*return Row(
      children: [
        Hero(
          tag: 'imageHero',
          child: AlbumPicture(
            track: widget.track,
            size: 25.0,
          ),
        ),
        ListTile(
          leading: AlbumPicture(
            track: widget.track,
            size: 25.0,
          ),
          title: Text(widget.track.name),
          subtitle: Text(widget.track.artists[0].name),
          trailing: IconButton(
            onPressed: () {
              dynamic tmp = _menuKey.currentState;
              tmp.showButtonMenu();
            },
            icon: Icon(Icons.more_vert),
          ),
          //trailing: icon,
          //isThreeLine: true,
          // Interactividad:
          //onTap: () async {},
          //onLongPress: () => _pressCallback,
          //enabled: false,
          //selected: true,
        ),
      ],
    );*/
  }
}
