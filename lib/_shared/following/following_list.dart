import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/following_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/following/following_item.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_bloc.dart';

class FollowingList extends StatefulWidget {
  final Key key;
  final List<Following> list;
  final bool loading;

  FollowingList({this.list, this.loading, this.key}) : super(key: key);

  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  FollowingBloc fb;

  BuildContext _context;
  TextEditingController _textController;
  bool _textEmpty = true;
  SearchBloc<Following> sb;

  @override
  void initState() {
    super.initState();

    fb = FollowingBloc(widget.list);

    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _textEmpty = _textController.text.isEmpty;
      });
    });

    sb = SearchBloc(
      searcher: fb,
      filter: (Following str, String query) =>
          Filters.contains(str.name, query) ||
          Filters.contains(str.suserid, query),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }

    /*var bloc = BlocProvider.of<SpotifyBloc>(context);
    return _buildTree(bloc);*/

    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            _buildSliverAppBar(context),
          ],
          body: _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text('ShareTheTrack Users'),
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
                    value: ConstantsOrderOptionsFollowing.FollowingName,
                    child: Text(ConstantsOrderOptionsFollowing.FollowingName),
                  ),
                  const PopupMenuItem<String>(
                    value: ConstantsOrderOptionsFollowing.FollowingId,
                    child: Text(ConstantsOrderOptionsFollowing.FollowingId),
                  ),
                ],
              )
            : Container()),
      ],
    );
  }

  Widget _buildBody(SpotifyService state) {
    if (widget.loading != null && widget.loading == true) {
      return LoadingScreen();
    }

    if (widget.list == null || widget.list.isEmpty) {
      return ErrorScreen(
        title: 'No Users Found Here',
      );
    }
    final list = widget.list;
    if (list == null) {
      return LoadingScreen();
    }

    Following myFollowings = widget.list
        .firstWhere((element) => element.fuserid == state.myFirebaseUserId);

    return StreamBuilder<List<Following>>(
        stream: fb.filteredData,
        builder: (context, snapshot) {
          final list = snapshot.data;
          if (list == null) {
            return LoadingScreen();
          }

          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return FollowingItem(
                  key: Key(item.suserid),
                  myFollowings: myFollowings,
                  suserid: item.suserid,
                  //following: item,
                );
              });
        });
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
                            hintText: "Search users by name or ID",
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
            Expanded(
                child: Container(
                    child: Center(
                        child: Text(
                            "Here are all the users who have signed up to the application.")))),
          ],
        ),
      ),
    );
  }

  Future choiceAction(String choice) async {
    if (choice == ConstantsOrderOptionsFollowing.FollowingName) {
      fb.add(OrderUsersNameEvent());
    } else if (choice == ConstantsOrderOptionsFollowing.FollowingId) {
      fb.add(OrderUsersIddEvent());
    }
  }
}
