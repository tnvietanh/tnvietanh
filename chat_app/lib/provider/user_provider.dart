import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  UsersProvider({required this.prefs});

  String getIdSharedPreferences() {
    return prefs.getString('id') ?? '';
  }

  String getNameSharedPreferences() {
    return prefs.getString('userName') ?? '';
  }

  Stream<QuerySnapshot> getUserByUserName(String userName) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .snapshots();
  }

  Stream<QuerySnapshot> getCurrentName() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: prefs.getString('id'))
        .snapshots();
  }

  Stream<QuerySnapshot> getUserAvatar(userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllUser() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Future<void> addMessage(String userId, chatMessageMap, timestamp) {
    final currentId = prefs.getString('id') ?? '';
    final String chatRoomId;
    if (currentId.compareTo(userId) > 0) {
      chatRoomId = '$currentId-$userId';
    } else {
      chatRoomId = '$userId-$currentId';
    }

    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('message')
        .doc(timestamp)
        .set(chatMessageMap);
  }

  Stream<QuerySnapshot> getMessages(String userId) {
    final currentId = prefs.getString('id') ?? '';
    final String chatRoomId;
    if (currentId.compareTo(userId) > 0) {
      chatRoomId = '$currentId-$userId';
    } else {
      chatRoomId = '$userId-$currentId';
    }
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void updateUserName(dataNeedUpdate) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .update(dataNeedUpdate);
    prefs.setString('userName', dataNeedUpdate['userName']);
  }

  void updateUserStatus(bool isOnline) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .update({'isOnline': isOnline});
  }

  UploadTask uploadFile(file) {
    Reference reference =
        FirebaseStorage.instance.ref().child(prefs.getString('id') ?? '');
    UploadTask uploadTask = reference.putFile(file);

    return uploadTask;
  }

  Future<String> getPhotoURL(userId) async {
    String photoURL =
        await FirebaseStorage.instance.ref(userId).getDownloadURL();
    Map<String, Object?> dataUpdate = {'photoURL': photoURL};
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(dataUpdate);

    return photoURL;
  }
}
