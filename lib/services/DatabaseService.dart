import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/models/suggestion.dart';

class DatabaseService {
  final String firebaseUserID;
  DatabaseService({this.firebaseUserID});

  final CollectionReference collection =
      Firestore.instance.collection("suggestions");

  Future updateUserData(
      String spotifyuserid, String trackid, String text) async {
    return await collection.document(spotifyuserid).setData({
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

  Stream<List<Suggestion>> get suggestions {
    return collection.snapshots().map(_suggestionListFromSnapshot);
  }

  static const String defaultTrackId = 'null';
}
