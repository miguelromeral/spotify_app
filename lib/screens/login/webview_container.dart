import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final grant;
  WebViewContainer(this.url, this.grant);
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
                print("Nav Req: ${navReq.url}");

                if (navReq.url.startsWith(SpotifyService.redirectUri)) {
                  if (navReq.url.toString().contains("?error=access_denied")) {
                    Navigator.pop(context, null);
                  }
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
