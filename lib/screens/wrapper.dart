import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/tabs_page.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'login/authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      condition: (pre, cur) => pre.logedin != cur.logedin,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: (state.logedin ? TabsPage() : Authenticate()),
        );
      },
    );
  }
}
