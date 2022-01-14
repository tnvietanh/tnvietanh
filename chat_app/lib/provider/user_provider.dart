import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  UsersProvider({required this.prefs});

  getUserByUserName(userName) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: userName)
          .get();
      notifyListeners();
      return user;
    } on Exception catch (e) {
      return e;
    }
  }

  Future getCurrentName() async {
    final currentName = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: prefs.getString('id'))
        .get()
        .then((value) => value.docs[0]['userName']);
    // print(currentName);
    notifyListeners();
    return currentName;
  }

  Future getCurrentAvatar() async {
    final currentName = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: prefs.getString('id'))
        .get()
        .then((value) => value.docs[0]['photoURL']);

    notifyListeners();
    return currentName;
  }

  getAllUser() async {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  getChatRoom() async {
    return FirebaseFirestore.instance.collection('chatRoom').snapshots();
  }

  Future<void> addMessage(String? chatRoomId, chatMessageMap, timestamp) {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('message')
        .doc(timestamp)
        .set(chatMessageMap);
  }

  getMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  updateUserName(dataNeedUpdate) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .update(dataNeedUpdate);
    prefs.setString('userName', dataNeedUpdate['userName']);
  }

  updateUserAvatar(dataNeedUpdate) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .update(dataNeedUpdate);
    prefs.setString('photoURL', dataNeedUpdate['photoURL']);
  }
}
