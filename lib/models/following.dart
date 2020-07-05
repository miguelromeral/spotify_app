import 'package:cloud_firestore/cloud_firestore.dart';

class Following {
  final String suserid;
  final String fuserid;
  final String users;
  final DocumentReference reference;

  //Suggestion({ this.trackid, this.suserid, this.fuserid });
  Following({this.suserid, this.fuserid, this.reference, this.users});

  List<String> get usersList {
    var list = users.split(delimiter);
    list.removeWhere((element) => element.isEmpty || element == "");
    return list;
  }

  static String concatenateUser(String previous, String suserid) {
    return '$previous$suserid$delimiter';
  }

  static String removeUser(List<String> users, String suserid) {
    users.remove(suserid);
    var text = '';
    for(var u in users){
      text = concatenateUser(text, u);
    }
    return text;
  }

  static String delimiter = ',';
}
