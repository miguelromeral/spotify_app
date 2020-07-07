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
        return PopupMenuButton<PopupItem>(
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
            child: _createItem(context),
            itemBuilder: (BuildContext context) => _getActions());
      },
    );
  }

  List<PopupMenuItem<PopupItem>> _getActions() {
    List<PopupMenuItem<PopupItem>> list = List();

    list.add(PopupItem.createListenOption(widget.track));
    list.add(PopupItem.createSuggestionOption(widget.track));

    return list;
  }

  ListTile _createItem(BuildContext context) {
    return ListTile(
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
    );
  }
}
