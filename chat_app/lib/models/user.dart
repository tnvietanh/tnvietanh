import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userName;
  String email;
  String photoURL;
  bool isOnline;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.photoURL,
    required this.isOnline,
  });
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String userName = '';
    String email = '';
    String photoURL = '';
    bool isOnline = false;

    userName =
        doc.data().toString().contains('userName') ? doc.get('userName') : '';

    email = doc.data().toString().contains('email') ? doc.get('email') : '';

    photoURL =
        doc.data().toString().contains('photoURL') ? doc.get('photoURL') : '';

    isOnline = doc.data().toString().contains('isOnline')
        ? doc.get('isOnline')
        : false;

    return UserModel(
      isOnline: isOnline,
      id: doc.id,
      userName: userName,
      email: email,
      photoURL: photoURL,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'email': email,
        'photoURL': photoURL,
        'isOnline': isOnline,
      };
}
