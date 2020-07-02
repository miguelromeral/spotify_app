import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/auth.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spotify_app/services/password_generator.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    automaticLogin(context);
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text('Hello!'),
      ),
      body: BlocBuilder<SpotifyBloc, SpotifyService>(
        builder: (context, state) {
          return Center(
            child: RaisedButton(
                child: Text('Log In'),
                onPressed: () async {
                  login(context);
                }),
          );
        },
      ),
    );
  }

  Future redirect(Uri authUri) async {
    if (await canLaunch(authUri.toString())) {
      await launch(authUri.toString());
    }
  }

  Future automaticLogin(BuildContext context) async {
    var credentials = await _loadCredentials();
    print("Credentials retrieved: ${credentials?.expiration}");
    if (credentials != null && credentials.expiration.isAfter(DateTime.now())) {
      print("automatically logining in");
      final spotify = SpotifyApi(credentials);
      context.bloc<SpotifyBloc>().add(LoginEvent(spotify));
    }
    print("End logging automatically.");
  }

  void login(BuildContext context) async {
    print("Getting credentials");

/*    var credentials = await _loadCredentials();
    if (credentials != null && credentials.expiration.isBefore(DateTime.now())) {
      final spotify = SpotifyApi(credentials);
      context.bloc<SpotifyBloc>().add(LoginEvent(spotify));
    } else {
  */ var    credentials = await SpotifyService.readCredentialsFile();
      final grant = SpotifyApi.authorizationCodeGrant(credentials);
      final scopes = ['user-read-email', 'user-library-read'];

      final authUri = grant.getAuthorizationUrl(
        Uri.parse(SpotifyService.redirectUri),
        scopes: scopes, // scopes are optional
      );

      await redirect(authUri);

      _sub = getUriLinksStream().listen((Uri uri) {
        print("listeniing: $uri");
        if (uri.toString().startsWith(SpotifyService.redirectUri)) {
          //responseUri = link;

          final spotify = SpotifyApi.fromAuthCodeGrant(grant, uri.toString());
          context.bloc<SpotifyBloc>().add(LoginEvent(spotify));

          _sub.cancel();
        }
      }, onError: (err) {
        // Handle exception by warning the user their action did not succeed
        print("Error while listening: $err");
      });
   // }
    print("End Clicking");
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
