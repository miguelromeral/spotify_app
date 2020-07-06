import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:spotify_app/screens/_shared/custom_appbar.dart';
import 'package:spotify_app/screens/home/feed_list.dart';
import 'package:spotify_app/screens/list_suggestions.dart';
import 'package:spotify_app/services/notifications.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class MySuggestionsScreen extends StatefulWidget {
  @override
  _MySuggestionsScreenState createState() => _MySuggestionsScreenState();
}

class _MySuggestionsScreenState extends State<MySuggestionsScreen> {
  List<Suggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      if (state.local_db != null) {
        return FutureBuilder(
          future: state.local_db.suggestions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Suggestion> list = snapshot.data;
              return ListSuggestions(
                suggestions: list,
              );
              //return Text("My Suggestions: ${list.length}");
            } else {
              return Text("Error");
            }
          },
        );
      } else {
        return Text("No Local DB");
      }
    });
  }

/*  TextEditingController _textFieldController = TextEditingController();

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
  }*/

}
