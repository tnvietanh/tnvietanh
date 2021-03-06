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
        Map<String, dynamic> userModel = UserModel(
          email: email,
          id: firebaseUser.uid,
          isOnline: true,
          photoURL: firebaseUser.photoURL ?? '',
          userName: firebaseUser.displayName ?? '',
        ).toJson();
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userModel);

        await prefs.setString('id', firebaseUser.uid);
        await prefs.setString('userName', firebaseUser.displayName ?? '');
        await prefs.setString('photoURL', firebaseUser.photoURL ?? '');
        // await prefs.setString('isOnline', userModel['isOnline'].toString());
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({'isOnline': true});
        DocumentSnapshot documentSnapshot = documents[0];
        UserModel userModel = UserModel.fromDocument(documentSnapshot);

        await prefs.setString('id', userModel.id);
        await prefs.setString('userName', userModel.userName);
        await prefs.setString('photoURL', userModel.photoURL);
        // await prefs.setString('isOnline', userModel.isOnline.toString());
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
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    }
  }

  Future<void> signOut() async {
    _status = Status.uninitialized;
    notifyListeners();
    await _auth.signOut();
    await prefs.clear();
  }
}
