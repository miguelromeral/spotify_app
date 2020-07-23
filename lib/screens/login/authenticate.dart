import 'dart:async';

import 'package:ShareTheMusic/_shared/app_logo.dart';
import 'package:ShareTheMusic/_shared/myicon.dart';
import 'package:ShareTheMusic/blocs/api_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/_shared/screens/loading_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/screens/login/webview_container.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  bool _acceptPolicy = false;

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
      body: Center(
        child: Container(
          decoration: backgroundGradient,
          child: BlocBuilder<SpotifyBloc, SpotifyService>(
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
                  return SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Text('Welcome to'),
                                      ScalingText(
                                        'ShareTheTrack',
                                        style: TextStyle(fontSize: 28.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: ListView(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GlowingProgressIndicator(
                                      child: AppLogo(),
                                      duration: Duration(seconds: 5),
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    _loginButton(context),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    RaisedButton(
                                        child:
                                            Text("Try the app's DEMO version"),
                                        textColor: Colors.white,
                                        color: colorThirdBackground,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: colorPrimary)),
                                        onPressed: () async {
                                          var mycredentials =
                                              await SpotifyService
                                                  .readCredentialsFile();
                                          final spotify =
                                              SpotifyApi(mycredentials);

                                          BlocProvider.of<ApiBloc>(context).add(
                                              UpdateApiEvent(newOne: spotify));

                                          context
                                              .bloc<SpotifyBloc>()
                                              .add(LoginAnonymousEvent());
                                        }),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          value: _acceptPolicy,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _acceptPolicy = value;
                                            });
                                          },
                                        ),
                                        Text(
                                            "By enabling this option, you agree with the app's Privacy Policy"),
                                      ],
                                    ),
                                    FlatButton(
                                        child: Text(
                                            'Click here to read the Privacy Policy'),
                                        textColor: Colors.white70,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WebViewContainer(
                                                    'https://github.com/miguelromeral/spotify_app/blob/master/PRIVACY-POLICY.md',
                                                    "ShareTheTrack's Privacy Policy",
                                                    (_) => NavigationDecision
                                                        .navigate)),
                                          );
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyIcon(
                                  icon: 'spotify',
                                  size: 24.0,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text("With the colaboration of Spotify"),
                              ],
                            ),
                          ),
                        ],
                      ),
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
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    if (_acceptPolicy) {
      return RaisedButton(
          child: Text('Log In with Spotify Account'),
          textColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: colorPrimary)),
          onPressed: () async {
            login(context);
          });
    } else {
      return RaisedButton(
          child: Text('Log In with Spotify Account'),
          textColor: Colors.grey,
          color: colorThirdBackground,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.grey)),
          onPressed: () async {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Please, accept Privacy Policy first"),
            ));
          });
    }
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
      var api = SpotifyApi(credentials); 
      BlocProvider.of<ApiBloc>(context).add(UpdateApiEvent(newOne: api));
      setState(() {
        _api = api;
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
                  'Log in with Spotify',
                  (navReq) {
                    print("Nav Req: ${navReq.url}");

                    if (navReq.url.startsWith(SpotifyService.redirectUri)) {
                      if (navReq.url
                          .toString()
                          .contains("?error=access_denied")) {
                        Navigator.pop(context, null);
                      }
                      try {
                        final spotify =
                            SpotifyApi.fromAuthCodeGrant(grant, navReq.url);

                        //   BlocProvider.of<SpotifyBloc>(context).add(LoginEvent(spotify, widget.remember));

                        Navigator.pop(context, spotify);
                      } catch (e) {
                        print("Error while redirecting: $e");
                      }

                      return NavigationDecision.prevent;
                    }

                    return NavigationDecision.navigate;
                  },
                )));
    if (res != null) {
      setState(() {
        _api = res;
        _state = _loginState.loading;
      });
      BlocProvider.of<ApiBloc>(context).add(UpdateApiEvent(newOne: res));
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
