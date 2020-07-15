import 'package:dio/dio.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/tracks/track_item.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';

class TrackList extends StatefulWidget {
  final List<Track> tracks;
  final String title;
  final bool refresh;

  TrackList({Key key, this.tracks, this.title, this.refresh}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  final ScrollController _controller = ScrollController();

  List<Track> list;

  BuildContext _context;

  Widget _buildList() {
    if (widget.refresh) {
      return RefreshIndicator(
        onRefresh: _getData,
        child: _listBuilder(),
      );
    } else {
      return _listBuilder();
    }
  }

  Widget _listBuilder() {
    return ListView.separated(
        controller: _controller,
        key: GlobalKey(),
        separatorBuilder: (context, index) => Divider(
              color: colorSeprator,
            ),
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (_, index) {
          return TrackItem(track: list[index]);
        });
    /*return DraggableScrollbar.arrows(
      backgroundColor: colorAccent,
      labelTextBuilder: (offset) {
        final int currentItem = _controller.hasClients
            ? (_controller.offset /
                    _controller.position.maxScrollExtent *
                    (list == null ? 0 : list.length))
                .floor()
            : -1;

        return Text(
          _getScrollThumbText(currentItem),
          style: TextStyle(color: Colors.black),
        );

      },
      labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
      controller: _controller,
      child: ListView.separated(
          controller: _controller,
          key: GlobalKey(),
          separatorBuilder: (context, index) => Divider(
                color: colorSeprator,
              ),
          itemCount: list == null ? 0 : list.length,
          itemBuilder: (_, index) {
            return TrackItem(track: list[index]);
          }),
    );*/
  }

  String _getScrollThumbText(int currentItem) {
    if (currentItem != -1 && currentItem < list.length) {
      return _getTrackNameShort(currentItem);
    } else if (currentItem == list.length) {
      return _getTrackNameShort(currentItem - 1);
    } else {
      return "";
    }
  }

  String _getTrackNameShort(int currentItem) {
    var item = list[currentItem];
    var text = (item.name.length < 10
        ? item.name
        : "${item.name.substring(0, 10)}...");
    return text;
  }

  Future<void> _getData() async {
    print("pulling to refresh in list_songs!");
    if (_context != null) {
      RefreshListNotification().dispatch(_context);
      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    list = widget.tracks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }

    return _buildList();

  }
}
