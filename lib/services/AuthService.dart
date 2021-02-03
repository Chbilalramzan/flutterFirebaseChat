import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat/models/Users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  bool login = false;
  bool logout = false;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = credential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
