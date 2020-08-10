import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/tracks/header_track_list.dart';
import 'package:ShareTheMusic/models/order.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotify_stats.dart';
import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/tracks/track_item.dart';
import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:ShareTheMusic/services/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';

import '../search_text_field.dart';

/// Creates the screen that shows a list of tracks
class TrackListScreen extends StatefulWidget {
  /// Key of this list of tracks
  final Key key;

  /// Title of the screen
  final String title;

  /// List of tracks to be shown
  final List<Track> list;

  /// Header of the sliver app bar
  final Widget header;

  /// Loading indicator, if the content below (the list) is not final
  final bool loading;

  TrackListScreen({this.key, this.list, this.title, this.header, this.loading});

  @override
  _TrackListScreenState createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  /// Track list bloc that filters the bloc according user preferences
  TrackListBloc tlb;

  /// Search bloc that uses the text filters in the lsit
  SearchBloc<Track> sb;

  TextEditingController _textController;
  // Indicates if the text field is empty
  bool _textEmpty = true;

  @override
  void initState() {
    // Initializes the bloc with the original list
    tlb = TrackListBloc(widget.list);

    // Listen to changes in the field
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _textEmpty = _textController.text.isEmpty;
      });
    });

    // Init the search using the filters
    sb = SearchBloc(
      searcher: tlb,
      filter: (Track str, String query) =>
          Filters.contains(str.name, query) ||
          Filters.contains(getArtists(str), query) ||
//          Filters.contains(str.artists[0].name, query) ||
          Filters.contains(str.album.name, query),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          _buildSliverAppBar(context),
        ],
        body: RefreshIndicator(
          onRefresh: () => _getData(context),
          child: _buildBody(),
        ),
      ),
    );
  }

  /// Dispatchs a notification for the upper widget to refresh the list
  Future<void> _getData(BuildContext context) async {
    if (context != null) {
      RefreshListNotification().dispatch(context);
      await Future.delayed(Duration(seconds: 10));
    }
  }

  /// Creates the sliver app bar
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(widget.title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      expandedHeight: 300.0,
      floating: false,
      pinned: false,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBar(context),
      ),
      actions: [
        // Show sort button only if the list is not empty
        (widget.list != null && widget.list.isNotEmpty
            ? PopupMenuButton<String>(
                onSelected: (String value) {
                  choiceAction(value);
                },
                child: Icon(Icons.sort),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
              )
            : Container()),
      ],
    );
  }

  /// Creates the actual body of the screen, with the list of tracks
  Widget _buildBody() {
    // Shows a loading screen meanwhile
    if (widget.loading != null && widget.loading == true) {
      return LoadingScreen();
    }

    // Streambuild to listen all changes in search criteria
    return StreamBuilder<List<Track>>(
      stream: tlb.filteredData,
      builder: (context, snapshot) {
        // If no original list, show an error
        if (widget.list == null || widget.list.isEmpty) {
          return ErrorScreen(
            title: 'No Tracks Found Here',
          );
        }

        final list = snapshot.data;
        if (list == null) {
          return LoadingScreen();
        }

        if (snapshot.hasError || list == null || list.isEmpty) {
          return ErrorScreen(
            title: 'No Tracks Found Here',
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: colorThirdBackground.withAlpha(150),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TrackItem(
                track: list[index],
              ),
            );
          },
          itemCount: list.length,
        );
      },
    );
  }

  /// Creates the app bar
  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Space to avoid the text field be hidden by the app bar title
            SizedBox(
              height: 50.0,
            ),

            // TextField if the list is not null
            SearchTextField(
              list: widget.list,
              controller: _textController,
              textEmpty: _textEmpty,
              hint: "Search users by name or ID",
              searchbloc: sb,
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    // Header of the sliver app bar
                    child: (widget.header ?? Container()),
                  ),
                  Expanded(
                    flex: 2,
                    // Track stats with the filtered data
                    child: StreamBuilder(
                      stream: tlb.filteredData,
                      builder: (context, snapshot) => HeaderTrackList(
                        list: snapshot.data,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Send an event depend on the sort choice
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
