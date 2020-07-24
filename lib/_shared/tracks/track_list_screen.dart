import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/_shared/custom_card.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:search_app_bar/search_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/tracks/track_item.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';

import '../myicon.dart';

class TrackListScreen extends StatefulWidget {
  final Key key;
  final String title;
  final List<Track> list;
  final Widget widget;

  TrackListScreen({this.key, this.list, this.title, this.widget});

  @override
  _TrackListScreenState createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  TrackListBloc tlb;

  TextEditingController _textController;
  bool _textEmpty = true;

  @override
  void initState() {
    //tlb = TrackListBloc(widget.list.map((e) => e.name).toList());
    tlb = TrackListBloc(widget.list);

    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _textEmpty = _textController.text.isEmpty;
      });
    });

    sb = SearchBloc(
      searcher: tlb,
      filter: (Track str, String query) =>
          Filters.contains(str.name, query) ||
          Filters.contains(str.artists[0].name, query) ||
          Filters.contains(str.album.name, query),
    );

    super.initState();
  }

  SearchBloc<Track> sb;

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: ErrorScreen(
            title: "There's no tracks.",
            safeArea: true,
          ));
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: StreamBuilder<List<Track>>(
          stream: tlb.filteredData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final list = snapshot.data;
            /*return TrackList(
              key: Key(list.hashCode.toString()),
              tracks: list,
              title: widget.title,
              refresh: true,
            );*/

            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                //expandedHeight: MediaQuery.of(context).size.height / 3,
                expandedHeight: 300.0,
                floating: false,
                pinned: false,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildAppBar(context),
                ),
                // actions: [],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index < list.length) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: colorThirdBackground.withAlpha(150),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TrackItem(
                          track: list[index],
                        ),
                      );
                    }
                  },
                  // Or, uncomment the following line:
                  // childCount: 3,
                ),
              )
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _textController,
                    showCursor: true,
                    onChanged: sb.onSearchQueryChanged,
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      filled: false,
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: "Search tracks by name, album or artist",
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: (_textEmpty
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _textController.clear();
                            sb.onSearchQueryChanged('');
                          },
                        )),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 4.0, 0.0),
                    child: PopupMenuButton<String>(
                      onSelected: (String value) {
                        choiceAction(value);
                      },
                      child: Icon(Icons.sort),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: ConstantsOrderOptions.TrackName,
                          child: Text(ConstantsOrderOptions.TrackName),
                        ),
                        const PopupMenuItem<String>(
                          value: ConstantsOrderOptions.Artist,
                          child: Text(ConstantsOrderOptions.Artist),
                        ),
                        const PopupMenuItem<String>(
                          value: ConstantsOrderOptions.Album,
                          child: Text(ConstantsOrderOptions.Album),
                        ),
                        const PopupMenuItem<String>(
                          value: ConstantsOrderOptions.ByDefault,
                          child: Text(ConstantsOrderOptions.ByDefault),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            (widget.widget ?? Container()),
          ],
        ),
      ),
    );
  }

  Future choiceAction(String choice) async {
    if (choice == ConstantsOrderOptions.TrackName) {
      tlb.add(OrderTrackName());
    } else if (choice == ConstantsOrderOptions.Artist) {
      tlb.add(OrderTrackArtist());
    } else if (choice == ConstantsOrderOptions.Album) {
      tlb.add(OrderTrackAlbum());
    } else if (choice == ConstantsOrderOptions.ByDefault) {
      tlb.add(OrderTrackDefault());
    }
  }
}
