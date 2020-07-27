import 'package:ShareTheMusic/_shared/suggestions/suggestion_loader.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/custom_sliver_appbar.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/suggestions/suggestion_item.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/custom_appbar.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

import '../styles.dart';

class HomeScreen extends StatefulWidget {
  static Key pageKey = new PageStorageKey("homescreen");

  HomeScreen() : super(key: pageKey);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<Suggestion> _storage;

  Widget _createScaffold(Widget content) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'My Friends Suggestions',
      ),
      body: content,
    );
  }

  @override
  void initState() {
    super.initState();

    /*_storage = PageStorage.of(context)
            .readState(context, identifier: ValueKey(HomeScreen.pageKey)) ??
        List();*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, MyApi>(
        builder: (context, api) =>
            api.showErrorIfNull(BlocBuilder<HomeBloc, HomeData>(
              builder: (context, data) {
                return BlocBuilder<SpotifyBloc, SpotifyService>(
                  builder: (context, state) {
                    return Center(
                      child: StreamBuilder(
                        stream: data.feed,
                        builder: (context, snp) {
                          if (snp.hasData) {
                            return buildBody(context, api, snp.data, state);
                          } else if (data.last.isNotEmpty) {
                            return buildBody(context, api, data.last, state);
                            /*} else if (snp.hasError) {
                            return _createScaffold(ErrorScreen(
                              title: 'Error while retrieving your feed.',
                            ));*/
                          } else {
                            _getData(context, state);
                            return buildBody(context, api, null, state);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            )));
  }

  Widget buildBody(BuildContext context, MyApi api, List<Suggestion> liked,
      SpotifyService state) {
    return NotificationListener<UpdatedFeedNotification>(
      onNotification: (notification) {
        _getData(context, state);
        return true;
      },
      child: _create(context, api, liked, state),
    );
  }

  Widget _create(BuildContext context, MyApi api, List<Suggestion> liked,
      SpotifyService state) {
    List<Suggestion> l = liked;
    bool loading = false;
    if (liked == null) {
      l = List<Suggestion>();
      loading = true;
    }
    return _createListNew(context, l, loading, state, api);
  }

  Widget _createListNew(BuildContext context, List<Suggestion> list,
      bool loading, SpotifyService state, MyApi api) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          _buildSliverAppBar(context, state),
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            _getData(context, state);
            //RefreshListNotification().dispatch(context);
            //await Future.delayed(Duration(seconds: 10));
          },
          child: _buildBody(loading, list, state, api),
        ),
        /*slivers: <Widget>[
            _buildBody(),
          ],*/
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, SpotifyService state) {
    return SliverAppBar(
      title: Text("My Friends Suggestions"),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ProfilePicture(
          user: state.myUser,
        ),
      ),
      backgroundColor: Colors.transparent,
      //expandedHeight: MediaQuery.of(context).size.height / 3,
      //expandedHeight: 300.0,
      floating: false,
      pinned: false,
      snap: false,
      /*flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBar(context),
      ),*/
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Center(
            child: Text("Ey!"),
          ),
        ],
      ),
    );
  }
/*
  Widget _createList(List<Suggestion> sugs, SpotifyService state, MyApi api) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          CustomSliverAppBar(title: 'My Firends Suggestion', state: state),
        ],
        body: NotificationListener<UpdatedFeedNotification>(
          onNotification: (notification) {
            _getData(context, state);
            return true;
          },
          child: Flexible(
              child: RefreshIndicator(
            onRefresh: () async {
              await _getData(context, state);
            },
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: colorSeprator,
                    ),
                itemCount: sugs.length,
                itemBuilder: (context, index) =>
                    _createListElement(sugs[index], state, api)),
          )),
        ),
      ),
    );
  }*/

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
    }
  }

  Future<void> _getData(BuildContext context, SpotifyService state) async {
    print("Getting Latest Feed");
    BlocProvider.of<HomeBloc>(context)
        .add(UpdateFeedHomeEvent(suggestions: await state.getsuggestions()));
    await Future.delayed(Duration(seconds: 10));
  }
}
