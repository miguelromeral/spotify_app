import 'package:firebase_auth/firebase_auth.dart';

/// Class that manages the authorization between Firebase and the app
class FirebaseAuthService {
  /// Firebase Auth Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current user loged
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  /// Allow the user to log in anonymously in order to test the demo version
  Future<FirebaseUser> signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Sign in with the email of Spotify and the password generated.
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    // Here there's no exception catching because it will be
    // managed in the function that call it.
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  /// Add a new user to the firebase database.
  Future<FirebaseUser> registerWithEmailAndPassword(
      String email, String password) async {
    // Here there's no exception catching because it will be
    // managed in the function that call it.
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  /// Log out of the app
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
