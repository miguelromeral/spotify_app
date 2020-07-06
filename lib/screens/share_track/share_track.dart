import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/_shared/custom_appbar.dart';
import 'package:spotify_app/services/notifications.dart';

class ShareTrack extends StatefulWidget {
  Track track;
  ShareTrack({this.track});

  @override
  _ShareTrackState createState() => _ShareTrackState();
}

class _ShareTrackState extends State<ShareTrack> {
  final _formKey = GlobalKey<FormState>();

  String _description = "Ey! Listen to this amazing track.";

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Share ${widget.track.name}',
      ),
      body: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TextFormField(
                    maxLength: 140,
                    initialValue: _description,
                    onChanged: (value) => setState(() {
                      _description = value;
                    }),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      /*if (value.isEmpty) {
                        return 'Please enter some text';
                      }*/
                      return null;
                    },
                  ),
                  RaisedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        var spUser = await state.myUser;
                        await state.db.updateUserData(
                            spUser.id, widget.track.id, _description);

                        bloc.add(UpdateFeed());
                        bloc.add(UpdateMySuggestion());
                        UpdatedFeedNotification().dispatch(context);



                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Updated Suggestion!')));

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ])),
          ),
        ),
      ),
    );
  }
}
