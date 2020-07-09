import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/_shared/myicon.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/_shared/popup/popup_item.dart';
import 'package:spotify_app/services/gui.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class CustomListTile extends StatefulWidget {
  final Key key;
  final Widget leadingIcon;
  final Widget trailingIcon;
  final List<Widget> content;
  final List<Widget> bottomIcons;
  final List<PopupMenuItem<PopupItem>> menuItems;

  CustomListTile(
      {@required this.key,
      this.leadingIcon,
      this.trailingIcon,
      this.content,
      this.bottomIcons,
      this.menuItems})
      : super(key: key);

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  final GlobalKey _menuKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Container(
          key: widget.key,
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
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        //color: Colors.black,
                        child: widget.leadingIcon,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.content),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: widget.trailingIcon,
                      ),
                    ),
                  ],
                ),
              ),
              _createBottomBar(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _createBottomBar(BuildContext context, SpotifyService state) {
    if (widget.bottomIcons != null && widget.bottomIcons.isNotEmpty) {
      if (widget.menuItems != null && widget.menuItems.isNotEmpty) {
        widget.bottomIcons.add(_createMenu(state));
      }
      return Container(
        //color: Colors.blue[300],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.bottomIcons,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _createMenu(SpotifyService state) {
    return PopupMenuButton<PopupItem>(
        key: _menuKey,
        onSelected: (PopupItem value) {
          switch (value.action) {
            case PopupActionType.vote:
              vote(context, state, value.suggestion, value.track);
              break;
            case PopupActionType.listen:
              value.openTrack();
              break;
            case PopupActionType.tosuggestion:
              value.updateSuggestion(context);
              break;
            case PopupActionType.openuser:
              value.openUser();
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
        itemBuilder: (BuildContext context) => widget.menuItems);
  }
}
