import 'package:ShareTheMusic/blocs/home_bloc.dart';
import 'package:ShareTheMusic/screens/demo/tabs_page_demo.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/tabs_page.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool firstLogin = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      condition: (pre, cur) =>
          pre.logedin != cur.logedin ||
          pre.deletingInfo != cur.deletingInfo ||
          pre.deletedInfo != cur.deletedInfo,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: (state.logedin ? _buildScreen(state) : Authenticate()),
        );
      },
    );
  }

  Widget _buildScreen(SpotifyService state) {
    if (state.demo) {
      /*return Scaffold(
        body: Center(child: Text("Demo")),
      );*/
      return TabsPageDemo();
    }
    if (firstLogin) {
      return Scaffold(
        body: FancyOnBoarding(
          doneButtonText: "Done",
          skipButtonText: "Skip",
          pageList: pagelist,
          onDoneButtonPressed: () => endOnboarding(),
          //Navigator.of(context).pushReplacementNamed('/mainPage'),
          onSkipButtonPressed: () => endOnboarding(),
          //Navigator.of(context).pushReplacementNamed('/mainPage'),
        ),
      );
    } else {
      return TabsPage();
    }
  }

  Future endOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('pref_first_login', false);

    setState(() {
      firstLogin = false;
    });
  }

  Future init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstLogin = prefs.getBool('pref_first_login') ?? true;
    });
  }

  final pagelist = [
    PageModel(
        color: const Color(0xFF66cc66),
        //heroAssetColor: Colors.black,
        heroAssetPath: 'assets/icons/app.png',
        title: Text('Welcome!',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: 34.0,
            )),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "First of all, we're so glad you've joined us in this project.",
                style: styleBlack,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "ShareTheTrack is a social app to allow the community discover new amazing tracks based on your likes.",
                style: styleBlack,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "In the next screens you'll learn how ShareTheTrack works and how to use it.",
                style: styleBlack,
              ),
            ],
          ),
        ),
        iconAssetPath: 'assets/icons/app_trans.png'),
    PageModel(
      color: const Color(0xFF39ac39),
      //heroAssetColor: Colors.black,
      heroAssetPath: 'assets/icons/home.png',
      title: Text('Home Screen',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Home Screen is the first page you'll see once you've loged into the app.",
              style: styleBlack,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "There you could see all of the suggestions of the users you are following.",
              style: styleBlack,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "All suggestions are displayed, no matter how long they were added.",
              style: styleBlack,
            ),
          ],
        ),
      ),
      iconAssetPath: 'assets/icons/home.png',
    ),
    PageModel(
      color: const Color(0xFF2d862d),
      //heroAssetColor: Colors.black,
      heroAssetPath: 'assets/icons/user.png',
      title: Text('Users',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You can follow any user in the app, no restrictions.",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "You can look for your friends in the drawer (swipe from left).",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "They won't know if you are following them, but their suggestions will be displayed to you anyway.",
              style: styleWhite,
            ),
          ],
        ),
      ),
      iconAssetPath: 'assets/icons/user.png',
    ),
    PageModel(
      color: const Color(0xFF206020),
      //heroAssetColor: Colors.black,
      heroAssetPath: 'assets/icons/sug_example.png',
      title: Text('Suggestions',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "The suggestions are the tracks you want to share with the community.",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "You only can have one suggestion, so when you update your suggestion, your followers won't see again the previous one.",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "You can vote your friends suggestion any times (clicking on the hand icon). They won't know whose votes are from. The votes are reset when you update the track.",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Wanted to add some info to your suggestion? Done! Add a short text to share with your followers why this track is your choice.",
              style: styleWhite,
            ),
          ],
        ),
      ),
      iconAssetPath: 'assets/icons/vote.png',
    ),
    PageModel(
      color: const Color(0xFF0d260d),
      heroAssetColor: Colors.white,
      heroAssetPath: 'assets/icons/spotify.png',
      title: Text('Privacy',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "We're concerned with privacy.",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Only your Spotify's ID and display name (apart from your tracks selection) will be shared with the other users.",
              style: styleWhite,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Through the app we'll retrieve your saved tracks and even your playlists, but they are only shown to you, in order to pick a track and make a suggestion.",
              style: styleWhite,
            ),
          ],
        ),
      ),
      iconAssetPath: 'assets/icons/spotify.png',
    ),
  ];

  static TextStyle styleBlack = TextStyle(color: Colors.black, fontSize: 18.0);
  static TextStyle styleWhite = TextStyle(color: Colors.white, fontSize: 18.0);
  static TextAlign align = TextAlign.center;
}
