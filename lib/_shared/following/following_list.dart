import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/search_text_field.dart';
import 'package:ShareTheMusic/blocs/following_bloc.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/following/following_item.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_bloc.dart';

/// List that shows and manage all following info
class FollowingList extends StatefulWidget {
  final Key key;

  /// List of following to show
  final List<Following> list;

  /// Indicates if the list passed is the final list or if it
  /// has to be updated, so meanwhile show a loading screen
  final bool loading;

  FollowingList({this.list, @required this.loading, this.key})
      : super(key: key);

  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  // Bloc that manages the following search
  FollowingBloc fb;
  // Search Bloc, allows to use filters
  SearchBloc<Following> sb;

  TextEditingController _textController;
  bool _textEmpty = true;

  @override
  void initState() {
    super.initState();

    // Initialize the following bloc
    fb = FollowingBloc(widget.list);

    // Listen when the textfield is not empty so as to show a delete icon if not.
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _textEmpty = _textController.text.isEmpty;
      });
    });

    // Filters for this list.
    sb = SearchBloc(
      searcher: fb,
      filter: (Following str, String query) =>
          Filters.contains(str.name, query) ||
          Filters.contains(str.suserid, query),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      expandedHeight: 300.0,
      floating: false,
      pinned: false,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBar(context),
      ),
      actions: [
        // Sort list items if not empty
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
        stringBelow: ["Please, try again later"],
      );
    }

    // From all the list of followings that we have, get ours,
    // so we can see wether we are following a user or not.
    Following myFollowings = widget.list
        .firstWhere((element) => element.fuserid == state.myFirebaseUserId);

    // We must have our info, if not, prevent the user to see the whole list.
    if (myFollowings == null)
      return ErrorScreen(
        title: "Problem while getting your following info",
        stringBelow: ["Please, try again later"],
      );

    // Listen to changes in search criteria
    return StreamBuilder<List<Following>>(
        stream: fb.filteredData,
        builder: (context, snapshot) {
          final list = snapshot.data;
          if (list == null) {
            return LoadingScreen();
          }

          if (list.isEmpty)
            return ErrorScreen(
              title: "No users with the info provided",
            );

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
            // Space to avoid being behind the Scaffold title
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
            // Rest of the header
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

  // Filter the list with the proper option choosen
  Future choiceAction(String choice) async {
    if (choice == ConstantsOrderOptionsFollowing.FollowingName) {
      fb.add(OrderUsersNameEvent());
    } else if (choice == ConstantsOrderOptionsFollowing.FollowingId) {
      fb.add(OrderUsersIddEvent());
    }
  }
}
