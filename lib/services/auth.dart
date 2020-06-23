import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Register with anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<FirebaseUser> currentUser() {
    return _auth.currentUser();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = await currentUser();
    await _auth.signInWithEmailAndPassword(
        email: user.email, password: currentPassword);
    await user.updatePassword(newPassword);
  }

  //Register with email & pass
  Future<bool> registerWithEmailAndPassword(
      String username, String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final fUser = result.user;

      final user = UserModel(uid: fUser.uid, username: username);
      await Firestore.instance
          .collection('user')
          .document()
          .setData(user.toMap());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

//signinwithemail&pass
  Future<AuthResult> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
