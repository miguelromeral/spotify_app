import 'package:ShareTheMusic/_shared/playlists/header_playlist_list.dart';
import 'package:ShareTheMusic/_shared/playlists/playlist_item.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/order.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/playlist_bloc.dart';
import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:ShareTheMusic/services/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';

import '../search_text_field.dart';

/// Screen to show all the playlist items.
class PlaylistsScreen extends StatefulWidget {
  final Key key;

  /// Title of the screen
  final String title;

  /// List of playlists to show
  final List<PlaylistSimple> list;

  /// widget header to show at the left of the sliver app bar
  final Widget header;

  /// Indicates if the screen is still loading
  final bool loading;

  PlaylistsScreen(
      {this.key, @required this.list, this.title, this.header, this.loading});

  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  // Bloc to manage the playlist items.
  PlaylistBloc tlb;
  // Search bloc to allow the playlist filter the results
  SearchBloc<PlaylistSimple> sb;

  TextEditingController _textController;
  // Indicates if the text field is empty
  bool _textEmpty = true;

  @override
  void initState() {
    // Initialize the bloc
    tlb = PlaylistBloc(widget.list);

    // Listen when the text field is empty or not
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _textEmpty = _textController.text.isEmpty;
      });
    });

    // Search criteria for the bloc
    sb = SearchBloc(
      searcher: tlb,
      filter: (PlaylistSimple str, String query) =>
          Filters.contains(str.name, query) ||
          Filters.contains(str.owner.displayName, query),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            _buildSliverAppBar(context, state),
          ],
          // Refresh the playlist by pulling the list
          body: RefreshIndicator(
            onRefresh: () => _getData(context),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  // Build the sliver app bar content
  Widget _buildSliverAppBar(BuildContext context, SpotifyService state) {
    return SliverAppBar(
      title: Text(widget.title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      expandedHeight: 300.0,
      floating: false,
      pinned: false,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBar(context, state),
      ),
      actions: [
        // Allow to filter the results only when the list is not empty
        (widget.list != null && widget.list.isNotEmpty
            ? PopupMenuButton<String>(
                onSelected: (String value) {
                  choiceAction(value);
                },
                child: Icon(Icons.sort),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: ConstantsOrderOptions.PlaylistName,
                    child: Text(ConstantsOrderOptions.PlaylistName),
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

  // Content of the flexible space in the sliver app bar
  Widget _buildAppBar(BuildContext context, SpotifyService state) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Space to avoid the title of the screen
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
                  // Header of the screen
                  Expanded(
                    flex: 1,
                    child:
                        (widget.header != null ? widget.header : Container()),
                  ),
                  // Stats of the results
                  Expanded(
                    flex: 1,
                    // Stream to listen to any changes in the list when filtering.
                    child: StreamBuilder<List<PlaylistSimple>>(
                        stream: tlb.filteredData,
                        builder: (context, snapshot) => HeaderPlaylistList(
                            list: snapshot.data, me: state.myUser)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action when sorting the list
  Future choiceAction(String choice) async {
    if (choice == ConstantsOrderOptions.PlaylistName) {
      tlb.add(OrderPlaylistName());
    } else if (choice == ConstantsOrderOptions.ByDefault) {
      tlb.add(OrderTrackDefault());
    }
  }

  // Build the body of the list
  Widget _buildBody() {
    // If it's not the final list, show loading screen.
    if (widget.loading != null && widget.loading == true) {
      return LoadingScreen(
        title: 'Loading Playlists...',
      );
    }

    // Stream to listen to any changes in list.
    return StreamBuilder<List<PlaylistSimple>>(
      stream: tlb.filteredData,
      builder: (context, snapshot) {
        // Error message if not list at all
        if (widget.list == null || widget.list.isEmpty || snapshot.hasError) {
          return ErrorScreen(
            title: 'No Playlists Found Here',
            stringBelow: [
              "Perhaps you don't have any Spotify playlist yet.",
              "If you do, then unfortunately we couldn't load them."
            ],
          );
        }

        // Get the filtered list.
        final list = snapshot.data;
        if (list == null) {
          return LoadingScreen();
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: colorThirdBackground.withAlpha(150),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: PlaylistItem(playlist: list[index]),
            );
          },
          itemCount: list.length,
        );
      },
    );
  }

  // Refresh callback. When the user pulls down the list.
  Future<void> _getData(BuildContext context) async {
    // Context required in order to dispatch the refresh
    if (context != null) {
      RefreshListNotification().dispatch(context);
      await Future.delayed(Duration(seconds: 10));
    }
  }
}
