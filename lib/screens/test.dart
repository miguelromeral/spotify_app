import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.brown[100],
          
          body: Center(
            child: FutureBuilder<User>(
              future: state.myUser,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data;
                  return Column(
                    children: [
                      Text(user.displayName),
                      
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        );
      },
    );
  }
}
