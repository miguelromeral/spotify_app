import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/following/following_item.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';

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
        Following myFollowings = fol
            .firstWhere((element) => element.fuserid == state.myFirebaseUserId);

        return Flexible(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: colorSeprator,
                    ),
                itemCount: fol.length,
                itemBuilder: (context, index) {
                  var item = fol[index];
                  /*if(state.db.firebaseUserID == item.fuserid){
                      bloc.add(UpdateFollowing());
                    }*/
                  return FollowingItem(
                    myFollowings: myFollowings,
                    suserid: item.suserid,
                    //following: item,
                  );
                }));
      });
    } else {
      return Center(child: Text('oops, no following.'));
    }
  }
}
