import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/_shared/custom_appbar.dart';
import 'package:spotify_app/screens/home/suggestions_list.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textFieldController = TextEditingController();
/*
  bool initDone = false;

  DateTime lastUpdate;
  List<Suggestion> list = List();

  @override
  void initState() {
    initDone = false;
    super.initState();
  }

  Future _retrieve(SpotifyService state) async {
    final res = await state.db.getsuggestions();
    setState(() {
      lastUpdate = state.lastSuggestionUpdate;
      list = res;
      initDone = true;
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    /*var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    if (state.lastSuggestionUpdate == null ||
        lastUpdate == state.lastSuggestionUpdate) {
      _retrieve(state);
    }*/

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      var bloc = BlocProvider.of<SpotifyBloc>(context);
      if (state.feed != null) {
        return NotificationListener<UpdatedFeedNotification>(
          onNotification: (notification) {
            print("Notification: $notification");
            setState(() {
              //_retrieve(state);
              bloc.add(UpdateFeed());
            });
            return true;
          },
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Feed',
            ),
            /*floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await _displayDialog(context, bloc);
                //_retrieve(state);
                bloc.add(UpdateFeed());
              },
              icon: Icon(Icons.add),
              label: Text("Follow New User"),
            ),*/
            body: Center(
              child: SuggestionsList(),
            ),
          ),
        );
      } else {
        bloc.add(UpdateFeed());
        return Text("Retreiving Stream...");
      }
    });
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
