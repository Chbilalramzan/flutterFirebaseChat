import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreMethods {
  Future<void> addUserInfo(String userDocId, userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userDocId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> checkIfUserExist(String uid) async =>
      (await FirebaseFirestore.instance.collection("users").doc(uid).get())
          .exists;

  /// Checks if the given username is already taken or not and returns the according bool.
  Future<bool> checkIfUsernameTaken(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();
    return result.docs.length > 0 ? true : false;
  }

  /// Checks if the given email is already taken or not and returns the according bool.
  Future<bool> checkIfEmailTaken(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: email)
        .get();
    return result.docs.length > 0 ? true : false;
  }
}
