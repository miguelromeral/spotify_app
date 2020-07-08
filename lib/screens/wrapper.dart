import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/tabs_page.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';

import 'login/authenticate.dart';
import 'home/home_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        Widget layout = Authenticate();
        if (state.logedin) {
          layout = TabsPage();
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: layout,
        );
      },
    );
  }
}
