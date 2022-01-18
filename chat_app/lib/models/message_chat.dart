import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  String message;
  String toUser;
  String timestamp;
  String idFrom;
  String idTo;

  MessageChat({
    required this.message,
    required this.toUser,
    required this.timestamp,
    required this.idFrom,
    required this.idTo,
  });

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String message = doc.get('message');

    String timestamp = doc.get('timestamp');
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');
    String toUser = doc.get('toUser');

    return MessageChat(
      toUser: toUser,
      message: message,
      timestamp: timestamp,
      idFrom: idFrom,
      idTo: idTo,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': timestamp,
      'idFrom': idFrom,
      'idTo': idTo,
      'toUser': toUser,
    };
  }
}
