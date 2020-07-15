import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/tracks/track_item.dart';
import 'package:ShareTheMusic/_shared/tracks/track_list.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';

class TrackListScreen extends StatefulWidget {
  final Key key;
  final String title;
  final List<Track> list;

  TrackListScreen({this.key, this.list, this.title});

  @override
  _TrackListScreenState createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
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
              return ConstantsOrderOptions.choices.map((String choice) {
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
    } else if (choice == ConstantsOrderOptions.ByDefault) {
      tlb.add(OrderTrackDefault());
    }
  }
}
