import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/custom_appbar.dart';
import 'package:spotify_app/custom_widgets/following_list.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  Future _retrieve(SpotifyBloc bloc) async {
    bloc.add(UpdateFollowing());
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);

    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        if (state.following != null) {

          return StreamProvider<List<Following>>.value(
            builder: (context, widget) {
              return Scaffold(
                appBar: CustomAppBar(
                  title: 'Follow App Users',
                ),
                /*floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await _displayDialog(context, bloc);
              _retrieve(state);
            },
            icon: Icon(Icons.add),
            label: Text("Follow New User"),
          ),*/
                body: Center(
                  child: FollowingList(),
                ),
              );
            },
            value: state.db.following,
          );
        } else {
          _retrieve(bloc);
          return Container(
            child: Center(
              child: Text('My Following Not Found'),
            ),
          );
        }
      },
    );
  }
}
