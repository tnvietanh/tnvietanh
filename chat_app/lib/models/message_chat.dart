import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  String message;
  String type;
  String timestamp;
  String idFrom;
  String idTo;

  MessageChat({
    required this.message,
    required this.type,
    required this.timestamp,
    required this.idFrom,
    required this.idTo,
  });

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String message = doc.get('message');
    String type = doc.get('type');
    String timestamp = doc.get('timestamp');
    String idFrom = doc.get('idFrom');
    String idTo = doc.get('idTo');

    return MessageChat(
      message: message,
      type: type,
      timestamp: timestamp,
      idFrom: idFrom,
      idTo: idTo,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'idFrom': idFrom,
      'idTo': idTo,
    };
  }
}
