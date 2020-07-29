import 'package:ShareTheMusic/_shared/playlists/playlist_item.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/playlist_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/blocs/track_list_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/notifications.dart';

class PlaylistsScreen extends StatefulWidget {
  final Key key;
  final String title;
  final List<PlaylistSimple> list;
  final Widget widget;
  final bool loading;
  final Function callback;

  PlaylistsScreen({this.key, this.list, this.title, this.widget, this.loading, this.callback});

  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  PlaylistBloc tlb;

  BuildContext _context;
  TextEditingController _textController;
  bool _textEmpty = true;
  SearchBloc<PlaylistSimple> sb;

  @override
  void initState() {
    tlb = PlaylistBloc(widget.list);

    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _textEmpty = _textController.text.isEmpty;
      });
    });

    sb = SearchBloc(
      searcher: tlb,
      filter: (PlaylistSimple str, String query) =>
          Filters.contains(str.name, query) ||
          Filters.contains(str.owner.displayName, query),
    );

    super.initState();
  }

  Future<void> _getData() async {
    if (_context != null) {
      RefreshListNotification().dispatch(_context);
      await Future.delayed(Duration(seconds: 10));
    }
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(widget.title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      //expandedHeight: MediaQuery.of(context).size.height / 3,
      expandedHeight: 300.0,
      floating: false,
      pinned: false,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBar(context),
      ),
      actions: [
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

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            (widget.list != null || widget.list.isNotEmpty
                ? Row(
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
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            filled: false,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Search playlists by name or owner",
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
                    ],
                  )
                : Container()),
            (widget.widget ?? Container()),
          ],
        ),
      ),
    );
  }

  Future choiceAction(String choice) async {
    if (choice == ConstantsOrderOptions.PlaylistName) {
      tlb.add(OrderPlaylistName());
    } else if (choice == ConstantsOrderOptions.ByDefault) {
      tlb.add(OrderTrackDefault());
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: Center(child: widget.widget),
    );*/
    if (_context == null) {
      _context = context;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          _buildSliverAppBar(context),
        ],
        body: RefreshIndicator(
          onRefresh: _getData,
          child: _buildBody(),
        ),
        /*slivers: <Widget>[
            _buildBody(),
          ],*/
      ),
    );
  }

  Widget _buildBody() {
    if (widget.loading != null && widget.loading == true) {
      return LoadingScreen();
    }

    return StreamBuilder<List<PlaylistSimple>>(
      stream: tlb.filteredData,
      builder: (context, snapshot) {
        /*if (!snapshot.hasData) {
          if (widget.list == null) return LoadingScreen();
          if (widget.list.isEmpty == null)
            return ErrorScreen(
              title: 'No tracks found here',
            );
        }*/
        if (widget.list == null || widget.list.isEmpty) {
          /*return SliverToBoxAdapter(
            child: LoadingScreen(),
          );*/
          return ErrorScreen(
            title: 'No Playlists Found Here',
            stringBelow: [
              "Perhaps you don't have any Spotify playlist yet.",
              "If you do, then unfortunately we couldn't load them."
            ],
          );
        }
        final list = snapshot.data;
        if (list == null) {
          return LoadingScreen();
        }

        //UpdateStatsPlaylistNotification(list: list).dispatch(context);

        if(widget.callback != null){
          widget.callback.call(list);
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
}
