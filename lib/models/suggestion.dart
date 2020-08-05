import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore class of a suggestion sent by a user in the app
class Suggestion {
  /// Spotify Track ID
  String trackid;

  /// Spotify Track ID Firestore Field
  static const String ftrackid = 'trackid';

  /// Spotify User ID
  String suserid;

  /// Spotify User ID Firestore Field
  static const String fsuserid = 'suserid';

  /// Firebase User ID
  String fuserid;

  /// Firebase User ID Firestore Field
  static const String ffuserid = 'fuserid';

  /// Message of the user for this track
  String text;

  /// Message of the user Firestore Field
  static const String ftext = 'text';

  /// Date in which the suggestion was sent
  DateTime date;

  /// Data Firestore Field
  static const String fdate = 'date';

  /// Number of votes this suggestion has
  int likes;

  /// Numer of votes Firestore Field
  static const String flikes = 'likes';

  /// Private suggestion (not visible for anonymous users)
  bool private;

  /// Private suggestion Firestore Field
  static const String fprivate = 'private';

  /// Firestore Document Reference
  DocumentReference reference;

  Suggestion(
      {this.trackid,
      this.suserid,
      this.fuserid,
      this.text,
      this.date,
      this.likes,
      this.private,
      this.reference});

  /// Creates a suggestion from a firestore document snapshot
  Suggestion.fromDocumentSnapshot(DocumentSnapshot doc) {
    trackid = doc.data[ftrackid] ?? '';
    suserid = doc.data[fsuserid] ?? '';
    fuserid = doc.data[ffuserid] ?? '';
    text = doc.data[ftext] ?? '';
    date = DateTime.parse(doc.data[fdate]) ?? '';
    likes = doc.data[flikes] ?? 0;
    private = doc.data[fprivate] ?? false;
    reference = doc.reference;
  }

  /// Parses the following instance into a map
  Map<String, dynamic> toMap() {
    return {
      ftrackid: trackid,
      fsuserid: suserid,
      ffuserid: fuserid,
      fprivate: private,
      ftext: text,
      fdate: date.toString(),
      flikes: likes,
    };
  }

  /// Local DB query to create the table for this class
  static final String databaseCreateQuery =
      "CREATE TABLE $databaseName(id INTEGER PRIMARY KEY, $ftrackid TEXT, $fsuserid TEXT, $ffuserid TEXT, $ftext TEXT, $fdate TEXT, $flikes INTEGER, $fprivate INTEGER)";

  /// Local DB name of this table
  static final String databaseName = "suggestions";
}
