import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/screens/wrapper.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';

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
          theme: appTheme,
        ),
      ),
    );
  }
}