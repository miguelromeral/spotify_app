import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
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

import '../myicon.dart';

class SuggestionsScreen extends StatefulWidget {
  final key;
  final bool loading;
  final List<Suggestion> list;
  final MyApi api;
  final String title;

  SuggestionsScreen({this.key, this.loading, this.list, this.api, this.title})
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
              onRefresh: () async {
                //_getData(context, state);
                RefreshListNotification().dispatch(context);
                //await Future.delayed(Duration(seconds: 10));
              },
              child: _buildBody(widget.loading, widget.list, state, widget.api),
            ),
            /*slivers: <Widget>[
              _buildBody(),
            ],*/
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, SpotifyService state) {
    return SliverAppBar(
      title: Text(widget.title),
      centerTitle: true,
      leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (state.myUser != null
              ? ProfilePicture(
                  user: state.myUser,
                )
              : Image(image: AssetImage('assets/icons/app.png')))),
      backgroundColor: Colors.transparent,
      //expandedHeight: MediaQuery.of(context).size.height / 3,
      //expandedHeight: 300.0,
      floating: false,
      pinned: false,
      snap: false,
    );
  }

  Widget _buildBody(
      bool loading, List<Suggestion> list, SpotifyService state, MyApi api) {
    if (loading == true) {
      return LoadingScreen();
    }

    return SafeArea(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) =>
              _createListElement(list[index], state, api)),
    );
  }

  Widget _createListElement(Suggestion item, SpotifyService state, MyApi api) {
    if (item.trackid == FirestoreService.defaultTrackId) {
      return Container();
    } else {
      return SuggestionLoader(
        // Si añadimos esta key, se actualiza todo el item, no solo los likes.
        key: Key('${item.suserid}-${item.trackid}'),
        suggestion: item,
        api: api,
      );

      /*return ListTile(
        key: Key('${item.suserid}-${item.trackid}'),
        title: Text(item.suserid),
        subtitle: Text(item.trackid),
      );*/
    }
  }
}
