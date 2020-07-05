import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/models/following.dart';
import 'package:spotify_app/models/suggestion.dart';

class DatabaseService {
  final String spotifyUserID;
  final String firebaseUserID;
  DatabaseService({this.spotifyUserID, this.firebaseUserID});

  final CollectionReference cSuggestions =
      Firestore.instance.collection("suggestions");
  final CollectionReference cFollowing =
      Firestore.instance.collection("following");

  Future updateUserData(
      String spotifyuserid, String trackid, String text) async {
    return await cSuggestions.document(spotifyuserid).setData({
      'trackid': trackid,
      'suserid': spotifyuserid,
      'fuserid': firebaseUserID,
      'text': text,
      'date': DateTime.now().toString(),
      'likes': 0,
    });
  }

  Future likeSuggestion(Suggestion suggestion) async {
    return await suggestion.reference.updateData(<String, dynamic>{
      'likes': (suggestion.likes + 1),
    });
  }

  Future addFollowing(String suserid) async {
    var fol =  await getFollowing();
    return await fol.reference.updateData(<String, dynamic>{
      'users': Following.concatenateUser(fol.users, suserid),
    });
  }

  Future initializeFollowing() async {
    return await cFollowing.document(spotifyUserID).setData({
      'suserid': spotifyUserID,
      'fuserid': firebaseUserID,
      'users': Following.concatenateUser('', spotifyUserID),
    });
  }

  List<Suggestion> _suggestionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Suggestion(
        trackid: doc.data['trackid'] ?? '',
        suserid: doc.data['suserid'] ?? '',
        fuserid: doc.data['fuserid'] ?? '',
        text: doc.data['text'] ?? '',
        date: DateTime.parse(doc.data['date']) ?? '',
        likes: doc.data['likes'] ?? 0,
        reference: doc.reference,
      );
    }).toList();
  }

  Future<Following> getFollowing() async {
    var data = await cFollowing.document(spotifyUserID).get();
    return Following(
      fuserid: data['fuserid'],
      suserid: data['suserid'],
      users: data['users'],
      reference: data.reference,
    );
  }

  Future<List<Suggestion>> getsuggestions() async {
    try {
      var fol = await getFollowing();
      var list = fol.usersList;
      list.add(spotifyUserID);
      return cSuggestions
          .where('suserid', whereIn: list)
          .getDocuments()
          .then((QuerySnapshot value) {
        print("Obtained: $value");

        var tmp = _suggestionListFromSnapshot(value);
        tmp.forEach((element) {
          print(element.suserid);
        });

        return tmp;
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

  
  List<Following> _followingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Following(
        suserid: doc.data['suserid'] ?? '',
        fuserid: doc.data['fuserid'] ?? '',
        users: doc.data['users'] ?? '',
        reference: doc.reference,
      );
    }).toList();
  }


  Stream<List<Following>> get following {
    return cFollowing.snapshots().map(_followingListFromSnapshot);
  }

  static const String defaultTrackId = 'null';
}
