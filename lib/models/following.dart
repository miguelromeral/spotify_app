import 'package:cloud_firestore/cloud_firestore.dart';

class Following {
  String suserid;
  static const String fsuserid = 'suserid';
  String fuserid;
  static const String ffuserid = 'fuserid';
  String users;
  static const String fusers = 'users';
  String name;
  static const String fname = 'name';
  DocumentReference reference;
  int followedBy = 0;

  //Suggestion({ this.trackid, this.suserid, this.fuserid });
  Following({this.suserid, this.fuserid, this.reference, this.users});

  Following.fromMap(Map<String, dynamic> data){
    suserid = data[fsuserid] ?? '';
    fuserid = data[ffuserid] ?? '';
    users = data[fusers] ?? '';
    name = data[fname] ?? '';
  }

  Following.fromDocumentSnapshot(DocumentSnapshot doc) {
    suserid = doc.data[fsuserid] ?? '';
    fuserid = doc.data[ffuserid] ?? '';
    users = doc.data[fusers] ?? '';
    name = doc.data[fname] ?? '';
    reference = doc.reference;
  }

  Map<String, dynamic> toMap() {
    return {
      fsuserid: suserid,
      ffuserid: fsuserid,
      fusers: users,
      fname: name,
    };
  }

  List<String> get usersList {
    var list = users.split(delimiter);
    list.removeWhere((element) => element.isEmpty || element == "");
    return list;
  }

  int get followingCount => usersList.length;

  String concatenateUser(String suserid) {
    users = '$users$suserid$delimiter';
    return users;
  }

  String removeUser(String suserid) {
    var list = usersList;
    list.remove(suserid);
    users = '';
    for (var u in list) {
      users = concatenateUser(u);
    }
    return users;
  }

  static String delimiter = ',';
}
