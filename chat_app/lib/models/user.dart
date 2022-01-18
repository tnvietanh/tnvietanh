import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userName;
  String createdAt;
  String email;
  String photoURL;
  bool isOnline;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.photoURL,
    required this.isOnline,
    required this.createdAt,
  });
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String userName = '';
    String email = '';
    String photoURL = '';
    bool isOnline = false;
    String createdAt = '';

    try {
      // userName = doc['userName'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      userName =
          doc.data().toString().contains('userName') ? doc.get('userName') : '';
    } catch (e) {}

    try {
      // email = doc['email'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      email = doc.data().toString().contains('email') ? doc.get('email') : '';
    } catch (e) {}
    try {
      // photoURL = doc['photoURL'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      photoURL =
          doc.data().toString().contains('photoURL') ? doc.get('photoURL') : '';
    } catch (e) {}
    try {
      // isOnline = doc['isOnline'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      isOnline = doc.data().toString().contains('isOnline')
          ? doc.get('isOnline')
          : false;
    } catch (e) {}
    try {
      // createdAt = doc['createdAt'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      createdAt = doc.data().toString().contains('createdAt')
          ? doc.get('createdAt')
          : '';
    } catch (e) {}

    return UserModel(
      createdAt: createdAt,
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
        'createdAt': createdAt,
      };
}
