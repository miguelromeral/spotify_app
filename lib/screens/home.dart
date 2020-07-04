import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/album_picture.dart';
import 'package:spotify_app/custom_widgets/custom_appbar.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/custom_widgets/suggestions_list.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/notifications/SuggestionLikeNotification.dart';
import 'package:spotify_app/screens/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textFieldController = TextEditingController();

  bool initDone = false;
  List<Suggestion> list = List();

  @override
  void initState() {
    initDone = false;
    super.initState();
  }

  Future _retrieve(SpotifyService state) async {
    final res = await state.db.getsuggestions();
    setState(() {
      list = res;
      initDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    if (!initDone) {
      _retrieve(state);
    }

    if (list != null && list.isNotEmpty) {
      return NotificationListener<UpdatedFeedNotification>(
        onNotification: (notification) {
          print("Notification: $notification");
          setState(() {
            _retrieve(state);
          });
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Feed',
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await _displayDialog(context, bloc);
              _retrieve(state);
            },
            icon: Icon(Icons.add),
            label: Text("Follow New User"),
          ),
          body: Center(
            child: SuggestionsList(list: list),
          ),
        ),
      );
    } else {
      return Text("Retreiving Stream...");
    }
  }

  _displayDialog(BuildContext context, SpotifyBloc bloc) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('FOLLOW'),
                onPressed: () async {
                  var text = _textFieldController.text;
                  if (text.isNotEmpty) {
                    await bloc.state.db.addFollowing(text);
                    //bloc.add(UpdateFeed());
                    //UpdatedFeedNotification().dispatch(context);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
