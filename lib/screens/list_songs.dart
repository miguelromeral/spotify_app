import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/custom_widgets/album_picture.dart';
import 'package:spotify_app/screens/share_track.dart';

class ListSongs extends StatefulWidget {
  List<Track> tracks;

  ListSongs({Key key, this.tracks}) : super(key: key);

  @override
  _ListSongsState createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var state = bloc.state;

    return Flexible(
      child: ListView.builder(
          itemCount: widget.tracks.length,
          itemBuilder: (_, index) {
            Track saved = widget.tracks[index];
            return ListTile(
              leading: AlbumPicture(
                track: saved,
                size: 25.0,
              ),
              title: Text(saved.name),
              subtitle: Text(saved.artists[0].name),
              //trailing: icon,
              //isThreeLine: true,
              // Interactividad:
              onTap: () async {
                /*
                var spUser = await state.myUser;
                state.db.updateUserData(spUser.id, saved.id);*/
                //bloc.add(ShareTrackEvent(track: saved));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShareTrack(track: saved)),
                );

                print("Updated!");
              },
              //onLongPress: () => _pressCallback,
              //enabled: false,
              //selected: true,
            );
          }),
    );
  }
}
