import 'dart:io';

import 'package:chat_app/models/message_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  UsersProvider({required this.prefs});

  String getDataSharedPreferences(String key) {
    return prefs.getString(key) ?? '';
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

  Stream<QuerySnapshot> getUserAvatar(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllUser() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Future<void> addMessage(String userId, String userName, String text) {
    final currentId = prefs.getString('id') ?? '';

    Map<String, dynamic> chatMessageMap = MessageChat(
            toUser: userName,
            idFrom: currentId,
            idTo: userId,
            message: text,
            timestamp: DateTime.now().millisecondsSinceEpoch.toString())
        .toJson();

    final String chatRoomId;
    if (currentId.compareTo(userId) > 0) {
      chatRoomId = '$currentId-$userId';
    } else {
      chatRoomId = '$userId-$currentId';
    }

    chattingWith(userId);
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('message')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(chatMessageMap);
  }

  void chattingWith(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .collection('chattingWith')
        .doc(userId)
        .set({'id': userId});
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chattingWith')
        .doc(prefs.getString('id'))
        .set({'id': prefs.getString('id')});
  }

  Stream<QuerySnapshot> getUserChattingWith(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chattingWith')
        .where('id', isEqualTo: prefs.getString('id') ?? '')
        .snapshots();
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

  void updateCurrentUser(String dataNeedUpdate, dynamic value) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .update({dataNeedUpdate: value});
    if (value != true || value != false) {
      prefs.setString(dataNeedUpdate, value.toString());
    }
  }

  UploadTask uploadFile(File file, String folderName, String fileName) {
    Reference reference =
        FirebaseStorage.instance.ref(folderName).child(fileName);
    UploadTask uploadTask = reference.putFile(file);
    return uploadTask;
  }
}
