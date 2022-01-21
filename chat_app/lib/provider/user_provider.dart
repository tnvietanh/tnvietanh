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

  Stream<QuerySnapshot> getAllUser() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getDataUser(String data, dynamic value) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(data, isEqualTo: value)
        .snapshots();
  }

  Future<void> addMessage(String userId, String text, String type) {
    final currentId = prefs.getString('id') ?? '';

    Map<String, dynamic> chatMessageMap = MessageChat(
            message: text,
            type: type,
            idFrom: currentId,
            idTo: userId,
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

  void updateDataCurrentUser(String dataNeedUpdate, dynamic value, {bool}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .update({dataNeedUpdate: value});
    if (value != true && value != false) {
      prefs.setString(dataNeedUpdate, value);
    } else {
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
