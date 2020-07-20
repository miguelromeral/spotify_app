import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';

class FirestoreService {
  final String spotifyUserID;
  final String firebaseUserID;
  FirestoreService({this.spotifyUserID, this.firebaseUserID});

  final CollectionReference cSuggestions =
      Firestore.instance.collection("suggestions");
  final CollectionReference cFollowing =
      Firestore.instance.collection("following");

  static const String defaultTrackId = 'null';

  /// *******************************************
  ///
  /// SUGGESTIONS
  ///
  ///********************************************

  List<Suggestion> _suggestionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Suggestion.fromDocumentSnapshot(doc);
    }).toList();
  }

  Future<Suggestion> updateUserData(
      String spotifyuserid, String trackid, String text) async {
    var now = DateTime.now();
    await cSuggestions.document(spotifyuserid).setData({
      Suggestion.ftrackid: trackid,
      Suggestion.fsuserid: spotifyuserid,
      Suggestion.ffuserid: firebaseUserID,
      Suggestion.ftext: text,
      Suggestion.fprivate:
          Settings.getValue<bool>(settings_suggestion_private, false),
      Suggestion.fdate: now.toString(),
      Suggestion.flikes: 0,
    });
    return Suggestion(
        fuserid: firebaseUserID,
        suserid: spotifyUserID,
        trackid: trackid,
        text: text,
        date: now);
  }

  Future likeSuggestion(Suggestion suggestion) async {
    return await suggestion.reference.updateData(<String, dynamic>{
      Suggestion.flikes: suggestion.likes + 1,
    });
  }

  Future<Suggestion> getMySuggestion() async {
    return await getSuggestion(spotifyUserID);
  }

  Future<Suggestion> getSuggestion(String suserid) async {
    try {
      return Suggestion.fromDocumentSnapshot(
          await cSuggestions.document(suserid).get());
    } catch (err) {
      print("error while getting suggestion: $err");
      return null;
    }
  }

  Future<List<Suggestion>> getsuggestions() async {
    try {
      var fol = await getMyFollowing();
      var list = fol.usersList;
      list.add(spotifyUserID);
      return cSuggestions
          .where(Suggestion.fsuserid, whereIn: list)
          .getDocuments()
          .then((QuerySnapshot value) {
        /*var tmp = _suggestionListFromSnapshot(value);
        tmp.forEach((element) {
          print(element.suserid);
        });*/

        return _suggestionListFromSnapshot(value);
      }).catchError((onError) {
        print("Error: $onError");
        return null;
      });
    } catch (err) {
      print("error while getting stream: $err");
      return null;
    }
  }

  Future<List<Suggestion>> getPublicSuggestions() async {
    try {
      return cSuggestions
          .where(Suggestion.fprivate, isEqualTo: true)
          .getDocuments()
          .then((QuerySnapshot value) {
        return _suggestionListFromSnapshot(value);
      }).catchError((onError) {
        print("Error: $onError");
        return null;
      });
    } catch (err) {
      print("error while getting stream: $err");
      return null;
    }
  }

  Stream<List<Suggestion>> get suggestions {
    return cSuggestions.snapshots().map(_suggestionListFromSnapshot);
  }

  /// *******************************************
  ///
  /// FOLLOWING
  ///
  ///********************************************

  Future<List<Following>> searchFollowing(String query) async {
    return cFollowing
        .where(Following.fname, isGreaterThanOrEqualTo: query)
        .getDocuments()
        .then((QuerySnapshot value) => _followingListFromSnapshot(value));
    /*.catchError(onError){
        print("Error: $onError");
        return null;
    });*/
  }

  Future<Following> getMyFollowing() async {
    return getFollowingBySpotifyUserID(spotifyUserID);
  }

  Future<Following> getFollowingBySpotifyUserID(String suserid) async {
    var data = await cFollowing.document(suserid).get();
    return Following.fromDocumentSnapshot(data);
  }

  Future<bool> updateDisplayName(UserPublic me) async {
    try {
      var mine = await getMyFollowing();
      mine.reference.updateData(<String, dynamic>{
        Following.fname: me.displayName,
      });
      return true;
    } catch (e) {
      print("Error when adding following: $e");
    }
    return false;
  }

  Future<bool> addFollowing(Following fol, String suserid) async {
    try {
      fol.concatenateUser(suserid);
      Following toFollow = await getFollowingBySpotifyUserID(suserid);
      if (toFollow != null) {
        await fol.reference.updateData(<String, dynamic>{
          Following.fusers: fol.users,
        });
        return true;
      }
    } catch (e) {
      print("Error when adding following: $e");
    }
    return false;
  }

  Future<bool> addFollowingByUserId(String suserid) async {
    Following fol = await getMyFollowing();
    return await addFollowing(fol, suserid);
  }

  Future removeFollowing(Following fol, String suserid) async {
    fol.removeUser(suserid);
    return await fol.reference.updateData(<String, dynamic>{
      Following.fusers: fol.users,
    });
  }

  Future initializeFollowing() async {
    Following init = Following(fuserid: firebaseUserID, suserid: spotifyUserID);
    init.concatenateUser(spotifyUserID);
    return await cFollowing.document(spotifyUserID).setData(init.toMap());
  }

  List<Following> _followingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Following.fromDocumentSnapshot(doc);
    }).toList();
  }

  Stream<List<Following>> get following {
    return cFollowing.snapshots().map(_followingListFromSnapshot);
  }

  Future<List<Following>> getFollowers(String spotifyUserId) async {
    var me = getFollowingBySpotifyUserID(spotifyUserId);
    var all = await cFollowing.getDocuments().then(_followingListFromSnapshot);
    List<Following> total = List();
    for (var f in all) {
      //if(f.users.contains(me.suserid)){
      if (f.suserid != spotifyUserId && f.users.contains(spotifyUserId)) {
        total.add(f);
      }
    }
    return total;
  }
}
