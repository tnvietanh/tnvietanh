import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticating,
  authenticated,
  authenticateError,
}

class AuthProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  AuthProvider({required this.prefs});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Status _status = Status.uninitialized;
  Status get status => _status;

  String? getIdSharedPreferences() {
    return prefs.getString('id');
  }

  String? getNameSharedPreferences() {
    return prefs.getString('userName');
  }

  Future<bool> isLoggedIn() async {
    if (prefs.getString('id')?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _status = Status.authenticating;
    notifyListeners();
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? firebaseUser = credential.user;
    if (firebaseUser != null) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // Writing data to server because here is a new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'id': firebaseUser.uid,
          'userName': firebaseUser.displayName,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'photoURL': firebaseUser.photoURL,
        });

        // Write data to local storage

        await prefs.setString('id', firebaseUser.uid);
        await prefs.setString('userName', firebaseUser.displayName ?? "");
        // await prefs.setString('photoUrl', currentUser.photoURL ?? "");
      } else {
        // Already sign up, just get data from firestore
        DocumentSnapshot documentSnapshot = documents[0];
        UserModel userModel = UserModel.fromDocument(documentSnapshot);
        // Write data to local
        await prefs.setString('id', userModel.id);
        await prefs.setString('userName', userModel.userName);
        // await prefs.setString('photoUrl', userModel.photoUrl);

      }
      _status = Status.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }
  }

  Future signup(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user!;
      await user.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _status = Status.uninitialized;
    await _auth.signOut();
    await prefs.clear();
  }
}
