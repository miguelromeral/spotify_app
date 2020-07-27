import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/_shared/explicit_badge.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/_shared/users/profile_picture.dart';
import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/blocs/localdb_bloc.dart';
import 'package:ShareTheMusic/screens/home/home_screen.dart';
import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/_shared/tracks/album_picture.dart';
import 'package:ShareTheMusic/_shared/custom_appbar.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/local_database.dart';

class ShareTrack extends StatefulWidget {
  final Track track;

  ShareTrack({this.track});

  @override
  _ShareTrackState createState() => _ShareTrackState();
}

class _ShareTrackState extends State<ShareTrack> {
  final _formKey = GlobalKey<FormState>();

  //String _description = "Ey! Listen to this amazing track.";
  String _description =
      (Settings.getValue<bool>(settings_suggestion_message_enabled, false)
          ? Settings.getValue<String>(settings_suggestion_message, '')
          : '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: FancyBackgroundApp(
              child: BlocBuilder<SpotifyBloc, SpotifyService>(
                builder: (context, state) => BlocBuilder<LocalDbBloc, LocalDB>(
                  condition: (pre, cur) => pre.isInit != cur.isInit,
                  builder: (context, localdb) {
                    return _buildBody(state, localdb, context);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              centerTitle: true,
              title: Text(widget.track.name), // You can add title here
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0, //No shadow
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      SpotifyService state, LocalDB localdb, BuildContext context) {
    if (localdb != null) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                // TODO: cambiarlos expanded o ver como podemos hacer para qu eesta parte de la pantalla
                // se vea bien en horizontal y sin overflow
                Container(
                  padding: EdgeInsets.all(40.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 125.0,
                        maxWidth: 125.0,
                        minHeight: 50.0,
                        minWidth: 50.0),
                    child: Hero(
                      tag: widget.track.hashCode.toString(),
                      child: AlbumPicture(
                        showDuration: false,
                        track: widget.track,
                        size: 125.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.track.name, style: styleFeedTitle),
                      SizedBox(
                        height: 8.0,
                      ),
                      _createRowData(
                        'Artist',
                        Text(
                          widget.track.artists
                              .map((e) => e.name)
                              .toString()
                              .replaceAll('(', '')
                              .replaceAll(')', ''),
                          style: styleFeedTrack,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      _createRowData(
                        'Album',
                        Text(widget.track.album.name),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      _createRowData(
                        'Duration',
                        Text('${printDuration(widget.track.durationMs)}'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      _createRowData(
                        'Popularity',
                        Text('${widget.track.popularity} %'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      _createRowData(
                        'Track Numer',
                        Text('#${widget.track.trackNumber}'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      (widget.track.explicit
                          ? _createRowData(
                              '',
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [ExplicitBadge()]),
                            )
                          : Container()),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.0,
                            child: ProfilePicture(
                              user: state.myUser,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Text('Recommend as ${state.myUser.displayName}:',
                              style: styleFeedTitle),
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText:
                                        'Write an optional message for your suggestion.',
                                  ),
                                  maxLength: 140,
                                  minLines: 1,
                                  maxLines: 5,
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white)),
                                  onPressed: () async {
                                    // Validate returns true if the form is valid, otherwise false.
                                    if (_formKey.currentState.validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.

                                      if (state.demo) {
                                        showMyDialog(
                                            context,
                                            'Log In For Full Access!',
                                            "Would you like to share this track with your followers?\n"
                                                "Please, log in with your spotify account to share it with the community.");
                                      } else {
                                        var spUser = state.myUser;
                                        var sug = await state.updateUserData(
                                            spUser.id,
                                            widget.track.id,
                                            _description);

                                        var res = await localdb
                                            .insertSuggestion(sug);
                                        if (res) {
                                          var bloc =
                                              BlocProvider.of<SpotifyBloc>(
                                                  context);
                                          //bloc.add(UpdateFeed());
                                          bloc.add(UpdateMySuggestion());

                                          //UpdatedFeedNotification().dispatch(context);

                                          var others =
                                              await state.getsuggestions();

                                          BlocProvider.of<HomeBloc>(context)
                                              .add(UpdateFeedHomeEvent(
                                                  suggestions: others));

                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Updated Suggestion!')));

                                          Navigator.pop(context);
                                        } else {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Error while updating your suggestion.')));
                                        }
                                      }
                                    }
                                  },
                                  child: Text('SUBMIT'),
                                ),
                              ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      BlocProvider.of<LocalDbBloc>(context).add(InitLocalDbEvent());
      return LoadingScreen();
    }
  }

  Widget _createRowData(String title, Widget content) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 8,
            child: (title.isNotEmpty
                ? Text(
                    title,
                    style: styleCardHeader,
                    textAlign: TextAlign.right,
                  )
                : Container())),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child: content,
        ),
      ],
    );
  }
}
