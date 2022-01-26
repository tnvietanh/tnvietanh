import 'dart:io';

import 'package:chat_app/models/message_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  UserProvider({required this.prefs});

  String getDataSharedPreferences(String key) {
    return prefs.getString(key) ?? '';
  }

  Stream<QuerySnapshot> getAllUser() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getUser(String data, dynamic value) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(data, isEqualTo: value)
        .snapshots();
  }

  void addMessage(String chatRoomId, String userId, String text, String type) {
    final currentId = prefs.getString('id') ?? '';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, dynamic> chatMessageMap = MessageChat(
            message: text,
            type: type,
            idFrom: currentId,
            idTo: userId,
            timestamp: timestamp)
        .toJson();
    chattingWith(userId, timestamp);
    if (type == 'image') {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('images')
          .doc(timestamp)
          .set({
        'imageUrl': text,
        'timestamp': timestamp,
      });
    }
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('messages')
        .doc(timestamp)
        .set(chatMessageMap);
  }

  void chattingWith(String userId, String timestamp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('id'))
        .collection('chattingWith')
        .doc(userId)
        .set({
      'id': userId,
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chattingWith')
        .doc(prefs.getString('id'))
        .set({
      'id': prefs.getString('id'),
    });
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
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void deleteChatRoom(String userId) {
    final currentId = prefs.getString('id') ?? '';
    final String chatRoomId;
    if (currentId.compareTo(userId) > 0) {
      chatRoomId = '$currentId-$userId';
    } else {
      chatRoomId = '$userId-$currentId';
    }
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('messages')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('images')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentId)
        .collection('chattingWith')
        .doc(userId)
        .delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chattingWith')
        .doc(currentId)
        .delete();
    FirebaseStorage.instance.ref(chatRoomId).listAll().then((value) => {
          for (var doc in value.items)
            {FirebaseStorage.instance.ref(chatRoomId).child(doc.name).delete()}
        });
  }

  void updateDataCurrentUser(String dataNeedUpdate, dynamic value) {
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

  Stream<QuerySnapshot> getAllImage(chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('images')
        .orderBy('timestamp')
        .snapshots();
  }
}
