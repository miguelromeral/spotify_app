import 'package:ShareTheMusic/blocs/localdb_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/screens/wrapper.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';

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

class MyApp extends StatelessWidget {
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
          ],
          child: MaterialApp(
            home: Wrapper(),
            theme: appTheme,
          ),
        ));
  }
}


/*

  Widget _buildPreferenceSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Shared Pref'),
        Switch(
            value: _isUsingHive,
            onChanged: (newVal) {
              if (kIsWeb) {
                return;
              }
              _isUsingHive = newVal;
              setState(() {
                initSettings();
              });
            }),
        Text('Hive Storage'),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Light Theme'),
        Switch(
            value: _isDarkTheme,
            onChanged: (newVal) {
              _isDarkTheme = newVal;
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildClearCacheButton(context),
        RaisedButton(
          child: Text('open settings'),
          onPressed: () {
            openAppSettings(context);
          },
        ),
      ],
    );
  }

  void openAppSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AppSettings(),
    ));
  }

  Widget _buildClearCacheButton(BuildContext context) {
    return RaisedButton(
      child: Text('Clear selected Cache'),
      onPressed: () {
        Settings.clearCache();
        showSnackBar(
          context,
          'Cache cleared for selected cache.',
        );
      },
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}*/