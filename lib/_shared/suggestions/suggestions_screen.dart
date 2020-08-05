import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_loader.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows all the suggestions in a list
class SuggestionsScreen extends StatefulWidget {
  /// Indicates if the list is not final and it should show a loading screen meanwhile
  final bool loading;

  /// List of suggestions to show
  final List<Suggestion> list;

  /// Spotify Api
  final MyApi api;

  /// Title of the screen
  final String title;

  /// Header widget to show between the sliver app bar and the actual content of the screen
  final Widget header;


  /// Hero Animation for users in 
  final bool heroAnimation;

  SuggestionsScreen(
      {Key key, this.loading, this.list, this.api, this.title, this.heroAnimation, this.header})
      : super(key: key);

  @override
  SuggestionsScreenState createState() => SuggestionsScreenState();
}

class SuggestionsScreenState extends State<SuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              _buildSliverAppBar(context, state),
            ],
            body: RefreshIndicator(
              // Pulling to refresh, the data will be updated in the upper widgets
              onRefresh: () async {
                RefreshListNotification().dispatch(context);
              },
              child: _buildBody(widget.loading, widget.list, state, widget.api),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, SpotifyService state) {
    // If there's a header to show in the list, show it and
    // set some space to allow it
    if (widget.header != null) {
      return SliverAppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        expandedHeight: 300,
        flexibleSpace: FlexibleSpaceBar(
          background: widget.header,
        ),
        floating: false,
        pinned: false,
        snap: false,
      );
    }
    return SliverAppBar(
      title: Text(widget.title),
      centerTitle: true,
      // Show the user profile picture at the top left corner
      leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (state.myUser != null
              ? ProfilePicture(
                  user: state.myUser,
                )
              // In demo, show the app icon instead
              : Image(image: AssetImage('assets/icons/app.png')))),
      backgroundColor: Colors.transparent,
      expandedHeight: 0,
      // Space to the header
      flexibleSpace: FlexibleSpaceBar(
        background: widget.header,
      ),
      floating: false,
      pinned: false,
      snap: false,
    );
  }

  /// Body of the screen, the list of widgets
  Widget _buildBody(
      bool loading, List<Suggestion> list, SpotifyService state, MyApi api) {
    // if still loading, show a temporary screen
    if (loading == true) {
      return LoadingScreen();
    }

    // If the list is empty, show an error screen...
    if (list != null && list.isEmpty) {
      return SingleChildScrollView(
        // but allow to refresh
        physics: AlwaysScrollableScrollPhysics(),
        child: ErrorScreen(
          title: 'No Suggestions Found',
          stringBelow: [
            "Follow any user to start seing suggestions.",
            "If you are currently following any user, pull the screen to refresh."
          ],
        ),
      );
    }

    return SafeArea(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) =>
              _createListElement(list[index], state, api)),
    );
  }

  /// Creates a tile for the list with the suggestion.
  Widget _createListElement(Suggestion item, SpotifyService state, MyApi api) {
    return SuggestionLoader(
      heroAnimation: widget.heroAnimation,
      key: Key('${item.suserid}-${item.trackid}'),
      suggestion: item,
      api: api,
    );
  }
}
