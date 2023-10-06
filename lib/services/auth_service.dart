import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Sign up with email and password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Return null on success
    } on FirebaseAuthException catch  (e) {
      print(e.message);
      print(e.code);
      switch(e.code) {
        case "invalid-email":
          return 'Invalid email format';
          break;
        case "email-already-in-use":
          return 'Email already in use';
          break;
        case "operation-not-allowed":
          return 'Accounts are not enabled';
          break;
        case "weak-password":
          return 'Weak password';
          break;
        default:
          return e.code;
      }
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Return null on success
    } on FirebaseAuthException catch  (e) {
      print(e.message);
      switch(e.code) {
        case "INVALID_LOGIN_CREDENTIALS":
          return 'Wrong username or password';
        case 1:
          print('one!');
          break;
        case 2:
          print('two!');
          break;
        default:
          return e.code;
      }
    }
  }

  // Sign out
  Future signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}