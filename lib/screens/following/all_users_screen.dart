import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/_shared/following/following_list.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _createBody(context);
  }

  Widget _createBody(BuildContext context) {
    return FancyBackgroundApp(
      child: _createAllUsersScreen(context),
    );
  }

  Widget _createAllUsersScreen(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return StreamProvider<List<Following>>.value(
          builder: (context, widget) {
            var list = Provider.of<List<Following>>(context);
            if (list != null) {
              return Center(
                child: FollowingList(
                  //key: Key(list.hashCode.toString()),
                  list: list,
                  loading: list == null || list.isEmpty,
                ),
              );
            } else {
              return LoadingScreen();
            }
          },
          value: state.allFollowings,
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
    var success = await state.addFollowingByUserId(suserid);
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
