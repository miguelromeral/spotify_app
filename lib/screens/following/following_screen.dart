import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/_shared/custom_appbar.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/following/following_list.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return StreamProvider<List<Following>>.value(
          builder: (context, widget) {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'Follow App Users',
              ),
              body: Center(
                child: FollowingList(),
              ),
              floatingActionButton: FloatingActionButton.extended(
                key: GlobalKey(),
                onPressed: () async {
                  var bloc = BlocProvider.of<SpotifyBloc>(context);
                  await _displayDialog(context, bloc);
                  bloc.add(UpdateFeed());
                },
                icon: Icon(Icons.add),
                label: Text("Follow New User"),
              ),
            );
          },
          value: state.db.following,
        );
      },
    );
  }

  _displayDialog(BuildContext fcontext, SpotifyBloc bloc) async {
    return showDialog(
        context: fcontext,
        builder: (context) {
          return AlertDialog(
            title: Text('Follow User by its ID'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "User's ID"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('FOLLOW'),
                onPressed: () async {
                  var text = _textFieldController.text;
                  if (text.isNotEmpty) {
                    Navigator.of(context).pop();
                    _handleAddition(bloc.state, text, context);
                  }
                },
              )
            ],
          );
        });
  }

  Future _handleAddition(
      SpotifyService state, String suserid, BuildContext context) async {
    var success = await state.db.addFollowingByUserId(suserid);
    if (success) {
      _showDialog(
          "New Following", "You're now following the user with ID $suserid!");
    } else {
      _showDialog(
          "No User Found", "There's no user in the app with ID $suserid :(");
    }
  }

  void _showDialog(String title, String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
