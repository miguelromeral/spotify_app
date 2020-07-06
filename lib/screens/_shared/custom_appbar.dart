import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/_shared/profile_picture.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  String title;

  CustomAppBar({this.title}) : preferredSize = Size.fromHeight(60.0);


  @override 
   final Size preferredSize;  

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SpotifyBloc>(context).state;

    return AppBar(
        title: Row(
          children: [
            FutureBuilder<User>(
              future: state.myUser,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProfilePicture(
                    user: snapshot.data,
                    size: 40.0,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
            Text(title),
          ],
        ),
      );
  }

}