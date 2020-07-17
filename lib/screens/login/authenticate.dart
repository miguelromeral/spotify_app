import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/screens/login/webview_container.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

enum _loginState { loadingSaved, waitingUser, tokenRevoked, loading }

class _AuthenticateState extends State<Authenticate> {
  SpotifyApi _api;
  bool errorInLogin = false;
  //  TODO: ARREGLAR QUE SI EL TOKEN SE REVOCA, SE VUELVA A ESTA PANTALLA DE FORMA SEGURA
  _loginState _state = _loginState.loadingSaved;

  @override
  void initState() {
    automaticLogin();
    super.initState();
  }

  Future checkBloc(SpotifyService state) async {
    if (state == null) {
      setState(() {
        _state = _loginState.waitingUser;
      });
    }
  }

  Future _answerLoginError() async {
    setState(() {
      _state = _loginState.waitingUser;
    });
  }

  @override
  void dispose() {
    _api = null;
    super.dispose();
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _showSnackBar(var text, context) async {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login to ShareTheTrack!'),
      ),
      body: BlocBuilder<SpotifyBloc, SpotifyService>(
        builder: (context, state) {
          errorInLogin = state.errorInLogin;
          switch (_state) {
            case _loginState.waitingUser:
            case _loginState.tokenRevoked:
              if (_state == _loginState.tokenRevoked) {
                //print("Snackbar");
                /*var sb = SnackBar(
                    content: Text(
                        ));
                _scaffoldKey.currentState.showSnackBar(sb);*/
                _showSnackBar(
                    'Your session has expired. Please, log in manually.',
                    context);
                //Scaffold.of(context).showSnackBar(sb);
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        child: Text('Log In'),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        onPressed: () async {
                          login(context);
                        }),
                  ],
                ),
              );
            case _loginState.loadingSaved:
              return LoadingScreen();
            case _loginState.loading:
              if (_api != null) {
                context.bloc<SpotifyBloc>().add(LoginEvent(_api, true));
              }
              return LoadingScreen(
                below: [
                  Text("Please, wait until you've been loged in."),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("This may take a few seconds."),
                ],
              );
            default:
              return ErrorScreen(
                title: 'Error while Login.',
                stringBelow: ['Please, try again later.'],
              );
          }
        },
      ),
    );
  }

  Future automaticLogin() async {
    setState(() {
      _state = _loginState.loadingSaved;
    });
    var credentials = await _loadCredentials();
    print("Credentials retrieved: ${credentials?.expiration}");
    //if (credentials != null && credentials.expiration.isAfter(DateTime.now())) {
    if (credentials != null) {
      print("automatically logining in");
      //context.bloc<SpotifyBloc>().add(LoginEvent(SpotifyApi(credentials), true));
      setState(() {
        _api = SpotifyApi(credentials);
        _state = _loginState.loading;
      });
      await Future.delayed(Duration(seconds: 3));
      if (errorInLogin) {
        setState(() {
          _state = _loginState.tokenRevoked;
        });
      }
    } else {
      setState(() {
        _state = _loginState.waitingUser;
      });
    }
  }

  void login(BuildContext context) async {
    var credentials = await SpotifyService.readCredentialsFile();
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final scopes = ['user-read-email', 'user-library-read'];

    final authUri = grant.getAuthorizationUrl(
      Uri.parse(SpotifyService.redirectUri),
      scopes: scopes, // scopes are optional
    );

    SpotifyApi res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(
                  authUri.toString(),
                  grant,
                )));
    if (res != null) {
      setState(() {
        _api = res;
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
