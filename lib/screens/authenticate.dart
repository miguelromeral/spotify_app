import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  StreamSubscription _sub;

  @override
  Widget build(BuildContext context) {
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
                  Login(context);
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

  void Login(BuildContext context) async {
    print("Getting credentials");
    final credentials = await SpotifyService.readCredentialsFile();

    print("End Getting credentials");
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final scopes = ['user-read-email', 'user-library-read'];

    final authUri = grant.getAuthorizationUrl(
      Uri.parse(SpotifyService.redirectUri),
      scopes: scopes, // scopes are optional
    );

    print("Ready to launch");

    await redirect(authUri);

    print("Ready to Listen");

    _sub = getUriLinksStream().listen((Uri uri) {
      print("listeniing: $uri");
      if (uri.toString().startsWith(SpotifyService.redirectUri)) {
        //responseUri = link;

        final spotify = SpotifyApi.fromAuthCodeGrant(grant, uri.toString());
        context.bloc<SpotifyBloc>().add(LoginEvent(spotify));

        _sub.cancel();
        print("We did it!");
        //return uri.toString();
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print("Error while listening: $err");
    });

    print("End Clicking");
  }


}


