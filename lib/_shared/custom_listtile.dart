import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/popup/popup_item_base.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

/// Our own list tile
class CustomListTile extends StatefulWidget {
  /// Content at the left
  final Widget leadingIcon;

  /// Content at the right
  final Widget trailingIcon;

  /// List of text content in the list tile
  final List<Widget> content;

  /// List of the icons and actions shown below the main content
  final List<Widget> bottomIcons;

  /// List of the menu options
  final List<PopupMenuItem<PopupItemBase>> menuItems;

  CustomListTile(
      {@required Key key,
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
  // Key for the menu
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon at the left
                    Expanded(
                      flex: 0,
                      child: Container(
                        child: widget.leadingIcon,
                      ),
                    ),
                    // Content of the list tile
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.content),
                      ),
                    ),
                    // Icon at the right
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        child: _createTrailingIcon(context, state),
                      ),
                    ),
                  ],
                ),
              ),
              // Bar of icons below the main content
              _createBottomBar(context, state),
            ],
          ),
        );
      },
    );
  }

  /// Creates the icon at the right. If neither icon nor bottom actions provided, show the menu button at the right
  Widget _createTrailingIcon(BuildContext context, SpotifyService state) {
    if (widget.trailingIcon == null && widget.bottomIcons == null) {
      if (widget.menuItems == null || widget.menuItems.isEmpty) {
        return Container();
      } else {
        return _createMenu(state);
      }
    } else {
      return widget.trailingIcon;
    }
  }

  /// Creates the bar of icons at the bottom
  Widget _createBottomBar(BuildContext context, SpotifyService state) {
    if (widget.bottomIcons != null && widget.bottomIcons.isNotEmpty) {
      if (widget.menuItems != null && widget.menuItems.isNotEmpty) {
        // If there's menu options to show, show them at the most left side
        widget.bottomIcons.add(SizedBox(
          width: 8.0,
        ));
        widget.bottomIcons.add(_createMenu(state));
      }
      // Show all the icons in a row
      return Container(
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

  /// Creates the menu of actions
  Widget _createMenu(SpotifyService state) {
    return PopupMenuButton<PopupItemBase>(
        key: _menuKey,
        onSelected: (PopupItemBase value) {
          value.execute(context);
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
