
import 'package:cloud_firestore/cloud_firestore.dart';

class Following {
  final String suserid;
  final String fuserid;
  final String users;
  final DocumentReference reference;
  
  //Suggestion({ this.trackid, this.suserid, this.fuserid });
  Following({ this.suserid, this.fuserid, this.reference, this.users });


  List<String> get usersList {
    return users.split(',');
  }

}