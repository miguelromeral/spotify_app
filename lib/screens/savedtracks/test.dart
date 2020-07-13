import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/_shared/tracks/track_item.dart';
import 'package:spotify_app/_shared/tracks/track_list.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/blocs/track_list_bloc.dart';
import 'package:spotify_app/screens/styles.dart';
import 'package:spotify_app/services/notifications.dart';

class Test extends StatefulWidget {
  final String title;
  final List<Track> list;

  Test({this.list, this.title});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  TrackListBloc tlb;

  @override
  void initState() {
    //tlb = TrackListBloc(widget.list.map((e) => e.name).toList());
    tlb = TrackListBloc(widget.list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar<Track>(
        title: Text(widget.title),
        searcher: tlb,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        searchElementsColor: Colors.white,
        searchBackgroundColor: colorAccent,
        filter: (Track str, String query) =>
            Filters.contains(str.name, query) ||
            Filters.contains(str.artists[0].name, query) ||
            Filters.contains(str.album.name, query),
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            child: Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<List<Track>>(
          stream: tlb.filteredData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final list = snapshot.data;
            return TrackList(
              key: Key(list.hashCode.toString()),
              tracks: list,
              title: widget.title,
              refresh: true,
            );
          },
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
    }
  }
}
