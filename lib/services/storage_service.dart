import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(int amount, String category, String thumbnail) {
    CollectionReference expenses = _firestore.collection('expenses');
    return expenses
        .add({
      'amount': amount,
      'category': category,
      'thumbnail': thumbnail
    }).then((value) => null)
        .catchError((error) => "Failed to add user: $error");
  }

}