import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestion {
  final String trackid;
  final String suserid;
  final String fuserid;
  final String text;
  final DateTime date;
  int likes;
  final DocumentReference reference;

  //Suggestion({ this.trackid, this.suserid, this.fuserid });
  Suggestion(
      {this.trackid,
      this.suserid,
      this.fuserid,
      this.text,
      this.date,
      this.likes,
      this.reference});

  Map<String, dynamic> toMap() {
    return {
      'trackid': trackid,
      'suserid': suserid,
      'fuserid': fuserid,
      'text': text,
      'date': date.toString(),
    };
  }
}
