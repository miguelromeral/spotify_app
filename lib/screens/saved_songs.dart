import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/album_picture.dart';
import 'package:spotify_app/custom_widgets/custom_appbar.dart';
import 'package:spotify_app/custom_widgets/profile_picture.dart';
import 'package:spotify_app/notifications/SuggestionLikeNotification.dart';
import 'package:spotify_app/screens/list_songs.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedSongs extends StatefulWidget {
  @override
  _SavedSongsState createState() => _SavedSongsState();
}

class _SavedSongsState extends State<SavedSongs> {
  SpotifyBloc _bloc;
  DateTime lastUpdate;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.of<SpotifyBloc>(context);
    }

    return BlocBuilder<SpotifyBloc, SpotifyService>(builder: (context, state) {
      print("Blocbuilder inside saved_songs.dart");
      if (state.saved != null) {
        print("Showing Saved, last: ${state.saved.first.name}");
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              BlocProvider.of<SpotifyBloc>(context).add(UpdateSaved());
              //await Future.delayed(Duration(seconds: 5));
              setState(() {
                lastUpdate = DateTime.now();
              });
            },
            icon: Icon(Icons.refresh),
            label: Text("Refresh"),
          ),
          body: Center(
            child: NotificationListener<RefreshListNotification>(
              onNotification: (notification) {
                print("Notification: $notification");
                /*setState(() {
                  //_retrieve(state);
                  bloc.add(UpdateFeed());
                });*/
                _getData();
                return true;
              },
              //child: RefreshIndicator(
              //  onRefresh: _getData,
              child: ListSongs(
                key: Key(state.saved.length.toString()),
                tracks: state.saved,
              ),
              //),
            ),
          ),
        );
      } else {
        BlocProvider.of<SpotifyBloc>(context).add(UpdateSaved());
        return Text("No Saved Songs");
//                  return CircularProgressIndicator();

      }
    });
  }

  Future<void> _getData() async {
    print("listened to the notification, updating!");
    if (_bloc != null) {
      _bloc.add(UpdateSaved());
      //BlocProvider.of<SpotifyBloc>(context).add(UpdateSaved());
      //await Future.delayed(Duration(seconds: 5));
      setState(() {
        lastUpdate = DateTime.now();
      });
    }
  }

  Future redirect(Uri authUri) async {
    if (await canLaunch(authUri.toString())) {
      await launch(authUri.toString());
    }
  }
}
