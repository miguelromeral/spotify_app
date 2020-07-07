import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/login/authenticate.dart';
import 'package:spotify_app/screens/wrapper.dart';
import 'package:spotify_app/services/firebase_auth.dart';
import 'package:spotify_app/services/spotifyservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuthService().user,
      child: BlocProvider<SpotifyBloc>(
        create: (context) => SpotifyBloc(),
        child: MaterialApp(
          home: Wrapper(),
        ),
      ),
    );
  }
}