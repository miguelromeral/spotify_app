import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for the following info in Firestore
class Following {
  /// Spotify User ID
  String suserid;

  /// Spotify User ID Firestore Field
  static const String fsuserid = 'suserid';

  /// Firebase User ID
  String fuserid;

  /// Firebase User ID Firestore Field
  static const String ffuserid = 'fuserid';

  /// String with the list of users who this user follows
  String users;

  /// Firestore Field with the list of followers
  static const String fusers = 'users';

  /// Spotify User Display Name
  String name;

  /// Display Name Firestore field
  static const String fname = 'name';

  /// Firestore Document Reference
  DocumentReference reference;

  /// Count of followers of this user
  int followedBy = 0;

  Following({this.suserid, this.fuserid, this.reference, this.users});

  /// Indicates if this user is following this spotify user id
  bool containsUser(String suserid) {
    return usersList.contains(suserid);
  }

  /// Creates the following info from a firestore document snapshot
  Following.fromDocumentSnapshot(DocumentSnapshot doc) {
    suserid = doc.data[fsuserid] ?? '';
    fuserid = doc.data[ffuserid] ?? '';
    users = doc.data[fusers] ?? '';
    name = doc.data[fname] ?? '';
    reference = doc.reference;
  }

  /// parses the following instance into a map
  Map<String, dynamic> toMap() {
    return {
      fsuserid: suserid,
      ffuserid: fuserid,
      fusers: users,
      fname: name,
    };
  }

  /// List of Spotify ID users who this user is following
  List<String> get usersList {
    var list = users.split(delimiter);
    list.removeWhere((element) => element.isEmpty || element == "");
    return list;
  }

  /// Number of users who this user is following
  int get followingCount => usersList.length;

  /// Add a new user id to the list of followings
  String concatenateUser(String suserid) {
    if (users == null) {
      users = '$suserid$delimiter';
      return users;
    }
    users = '$users$suserid$delimiter';
    return users;
  }

  /// Remove a user id from the current list of following
  String removeUser(String suserid) {
    var list = usersList;
    list.remove(suserid);
    users = '';
    for (var u in list) {
      users = concatenateUser(u);
    }
    return users;
  }

  /// Delimiter used in Firestore to separate the users ID
  static String delimiter = ',';
}
