import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/models/suggestion.dart';

class FirestoreService {
  final String spotifyUserID;
  final String firebaseUserID;
  FirestoreService({this.spotifyUserID, this.firebaseUserID});

  final CollectionReference cSuggestions =
      Firestore.instance.collection("suggestions");
  final CollectionReference cFollowing =
      Firestore.instance.collection("following");

  static const String defaultTrackId = 'null';

  /*********************************************
   * 
   * SUGGESTIONS
   * 
   *********************************************/

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
      'likes': (suggestion.likes + 1),
    });
  }

  Future<Suggestion> getMySuggestion() async {
    try {
      return Suggestion.fromDocumentSnapshot(await cSuggestions.document(spotifyUserID).get());
    } catch (err) {
      print("error while getting suggestion: $err");
      return null;
    }
  }

  Future<List<Suggestion>> getsuggestions() async {
    try {
      var fol = await getFollowing();
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

  Stream<List<Suggestion>> get suggestions {
    return cSuggestions.snapshots().map(_suggestionListFromSnapshot);
  }

  /*********************************************
   * 
   * FOLLOWING
   * 
   *********************************************/

  Future<Following> getFollowing() async {
    var data = await cFollowing.document(spotifyUserID).get();
    return Following.fromDocumentSnapshot(data);
  }

  Future addFollowing(Following fol, String suserid) async {
    fol.concatenateUser(suserid);
    return await fol.reference.updateData(<String, dynamic>{
      Following.fusers: fol.users,
    });
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
}
