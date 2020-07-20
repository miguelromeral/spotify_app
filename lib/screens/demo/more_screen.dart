import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemoMoreScreen extends StatefulWidget {
  @override
  _DemoMoreScreenState createState() => _DemoMoreScreenState();
}

class _DemoMoreScreenState extends State<DemoMoreScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Do you want to have full access to the app and its features?"),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                        "Then, log out of the DEMO version and log in with your Spotify Account."),
                    SizedBox(
                      height: 24.0,
                    ),
                    RaisedButton(
                        child: Text('Exit DEMO'),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        onPressed: () async {
                          BlocProvider.of<SpotifyBloc>(context)
                              .add(LogoutEvent());
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
