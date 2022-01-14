import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userName;
  String email;
  UserModel({
    required this.id,
    required this.userName,
    required this.email,
  });
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    String userName = '';
    String email = '';

    try {
      // userName = doc['userName'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      userName =
          doc.data().toString().contains('userName') ? doc.get('userName') : '';
    } catch (e) {}

    try {
      // email = doc['email'];   Bad state: field does not exist within the DocumentSnapshotPlatform
      email = doc.data().toString().contains('email') ? doc.get('email') : '';
    } catch (e) {}
    return UserModel(
      id: doc.id,
      userName: userName,
      email: email,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'email': email,
      };
}
