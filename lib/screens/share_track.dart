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
import 'package:spotify_app/screens/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

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
    var state = BlocProvider.of<SpotifyBloc>(context).state;

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
                        state.db.updateUserData(
                            spUser.id, widget.track.id, _description);


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
