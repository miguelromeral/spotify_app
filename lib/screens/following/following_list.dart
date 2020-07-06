import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_app/blocs/spotify_bloc.dart';
import 'package:spotify_app/screens/following/following_item.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class FollowingList extends StatefulWidget {
  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SpotifyBloc>(context);
    var list = Provider.of<List<Following>>(context);
    return _buildTree(bloc, list);
  }

  Widget _buildTree(SpotifyBloc bloc, List<Following> fol) {
    if (fol != null && fol.length > 0) {
      return BlocBuilder<SpotifyBloc, SpotifyService>(
        builder: (context, state) {
          Following myFollowings = fol.firstWhere(
              (element) => element.fuserid == state.db.firebaseUserID);

          return Flexible(
              child: ListView.builder(
                  itemCount: fol.length,
                  itemBuilder: (context, index) {
                    var item = fol[index];
                    /*if(state.db.firebaseUserID == item.fuserid){
                      bloc.add(UpdateFollowing());
                    }*/
                    return FutureBuilder(
                        future: state.api.users.get(item.suserid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserPublic user = snapshot.data;
                            return FollowingItem(
                              myFollowings: myFollowings,
                              user: user,
                              following: item,
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  }));
        },
      );
    } else {
      return Center(child: Text('oops, no feed.'));
    }
  }
}
