import 'package:chat_app/models/message_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  UsersProvider({required this.prefs});

  String getDataSharedPreferences(key) {
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

  Stream<QuerySnapshot> getUserAvatar(userId) {
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
    // updateChattingWith(userId);
    chattingWith(userId);
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('message')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(chatMessageMap);
  }

  // final List<String> currentIdChattingWith = [];
  // final List<String> listUserIdChattingWith = [];
  // void updateChattingWith(userId) {
  //   if (listUserIdChattingWith.contains(userId)) {
  //   } else {
  //     listUserIdChattingWith.add(userId);
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(prefs.getString('id'))
  //         .update({'chattingWith': listUserIdChattingWith});
  //   }

  //   if (currentIdChattingWith.contains(prefs.getString('id'))) {
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .update({'chattingWith': currentIdChattingWith});
  //   } else {
  //     currentIdChattingWith.add(prefs.getString('id') ?? '');
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .update({'chattingWith': currentIdChattingWith});
  //   }
  //   print(currentIdChattingWith);
  //   print(listUserIdChattingWith);
  // }

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
