import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/blocs/localdb_bloc.dart';
import 'package:ShareTheMusic/blocs/playlists_bloc.dart';
import 'package:ShareTheMusic/blocs/saved_tracks_bloc.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/screens/wrapper.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';
import 'package:spotify/spotify.dart';

import 'blocs/home_bloc.dart';

Future<void> main() async {
  await initSettings();
  runApp(MyApp());
}

Future<void> initSettings() async {
  await Settings.init(
    //cacheProvider: _isUsingHive ? HiveCache() : SharePreferenceCache(),
    cacheProvider: SharePreferenceCache(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // TODO: Manage dispose of blocs with streams. How?

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: FirebaseAuthService().user,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LocalDbBloc>(
              create: (BuildContext context) => LocalDbBloc(),
            ),
            BlocProvider<SpotifyBloc>(
              create: (BuildContext context) => SpotifyBloc(),
            ),
            BlocProvider<HomeBloc>(
              create: (BuildContext context) => HomeBloc(),
            ),
            BlocProvider<ApiBloc>(
              create: (BuildContext context) => ApiBloc(),
            ),
            BlocProvider<SavedTracksBloc>(
              create: (context) => SavedTracksBloc(),
            ),
            BlocProvider<PlaylistsBloc>(
              create: (context) => PlaylistsBloc(),
            )
          ],
          child: MaterialApp(
            home: FancyBackgroundApp(child: Wrapper()),
            theme: appTheme,
          ),
        ));
  }
}
