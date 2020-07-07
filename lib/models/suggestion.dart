import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestion {
  String trackid;
  static const String ftrackid = 'trackid';
  String suserid;
  static const String fsuserid = 'suserid';
  String fuserid;
  static const String ffuserid = 'fuserid';
  String text;
  static const String ftext = 'text';
  DateTime date;
  static const String fdate = 'date';
  int likes;
  static const String flikes = 'likes';
  DocumentReference reference;

  //Suggestion({ this.trackid, this.suserid, this.fuserid });
  Suggestion(
      {this.trackid,
      this.suserid,
      this.fuserid,
      this.text,
      this.date,
      this.likes,
      this.reference});

  Suggestion.fromDocumentSnapshot(DocumentSnapshot doc) {
    trackid = doc.data[ftrackid] ?? '';
    suserid = doc.data[fsuserid] ?? '';
    fuserid = doc.data[ffuserid] ?? '';
    text = doc.data[ftext] ?? '';
    date = DateTime.parse(doc.data[fdate]) ?? '';
    likes = doc.data[flikes] ?? 0;
    reference = doc.reference;
  }

  Map<String, dynamic> toMap() {
    return {
      ftrackid: trackid,
      fsuserid: suserid,
      ffuserid: fuserid,
      ftext: text,
      fdate: date.toString(),
    };
  }
}
