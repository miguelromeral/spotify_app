import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/screens/login/webview_container.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:url_launcher/url_launcher.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

enum _loginState { loadingSaved, waitingUser, loading }

class _AuthenticateState extends State<Authenticate> {
  bool _remember = false;
  _loginState _state = _loginState.loadingSaved;

  @override
  void initState() {
    setState(() {
      _state = _loginState.loadingSaved;
    });
    super.initState();
  }

  Widget _buildBody(BuildContext context) {
    switch (_state) {
      case _loginState.loadingSaved:
        automaticLogin(context);
        return Center(child: Text("Loading Saved Credentials..."));
        break;
      case _loginState.waitingUser:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                  child: Text('Log In'),
                  onPressed: () async {
                    login(context);
                  }),
              Text("Remember Credentials (1 hour)"),
              Checkbox(
                value: _remember,
                onChanged: (bool value) {
                  setState(() {
                    _remember = value;
                  });
                },
              ),
            ],
          ),
        );
        break;
      case _loginState.loading:
        return Center(child: Text("Loading..."));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello!'),
      ),
      body: BlocBuilder<SpotifyBloc, SpotifyService>(
        builder: (context, state) {
          if (state != null)
            return _buildBody(context);
          else
            setState(() {
              _state = _loginState.waitingUser;
            });
        },
      ),
    );
  }

  Future automaticLogin(BuildContext context) async {
    var credentials = await _loadCredentials();
    print("Credentials retrieved: ${credentials?.expiration}");
    if (credentials != null && credentials.expiration.isAfter(DateTime.now())) {
      print("automatically logining in");
      context
          .bloc<SpotifyBloc>()
          .add(LoginEvent(SpotifyApi(credentials), true));
      setState(() {
        _state = _loginState.loading;
      });
    } else {
      setState(() {
        _state = _loginState.waitingUser;
      });
    }
    print("End logging automatically.");
  }

  void login(BuildContext context) async {
    var credentials = await SpotifyService.readCredentialsFile();
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final scopes = ['user-read-email', 'user-library-read'];

    final authUri = grant.getAuthorizationUrl(
      Uri.parse(SpotifyService.redirectUri),
      scopes: scopes, // scopes are optional
    );

    var res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(
                  authUri.toString(),
                  grant,
                  _remember,
                )));
    if (res == true) {
      setState(() {
        _state = _loginState.loading;
      });
    } else {
      setState(() {
        _state = _loginState.waitingUser;
      });
    }
  }

  Future<SpotifyApiCredentials> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var accessToken = prefs.getString('accessToken') ?? "";
      var clientId = prefs.getString('clientId') ?? "";
      var clientSecret = prefs.getString('clientSecret') ?? "";
      var refreshToken = prefs.getString('refreshToken') ?? "";
      var scopes = prefs.getStringList('scopes') ?? List();
      var expiration = DateTime.parse(prefs.getString('expiration') ?? "");

      print("Expiration Date: ${expiration.toString()}");

      if (clientId.isNotEmpty && clientSecret.isNotEmpty) {
        return SpotifyApiCredentials(
          clientId,
          clientSecret,
          accessToken: accessToken,
          refreshToken: refreshToken,
          scopes: scopes,
          expiration: expiration,
        );
      }
    } catch (e) {
      print("Error while loading credentials");
      return null;
    }
  }
}
