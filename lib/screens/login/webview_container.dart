import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/spotifyservice.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final grant;
  final remember;
  WebViewContainer(this.url, this.grant, this.remember);
  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  _WebViewContainerState(this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (navReq) {
                if (navReq.url.startsWith(SpotifyService.redirectUri)) {
                  try {
                    final spotify =
                        SpotifyApi.fromAuthCodeGrant(widget.grant, navReq.url);

                 //   BlocProvider.of<SpotifyBloc>(context).add(LoginEvent(spotify, widget.remember));
                    

                    Navigator.pop(context, spotify);
                  } catch (e) {
                    print("Error while redirecting: $e");
                  }

                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ))
          ],
        ));
  }
}
