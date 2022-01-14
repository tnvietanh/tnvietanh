import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  String message;
  String sendBy;
  String timestamp;

  MessageChat({
    required this.message,
    required this.sendBy,
    required this.timestamp,
  });

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String message = doc.get('message');
    String sendBy = doc.get('sendBy');
    String timestamp = doc.get('timestamp');

    return MessageChat(
      message: message,
      sendBy: sendBy,
      timestamp: timestamp,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sendBy': sendBy,
      'timestamp': timestamp,
    };
  }
}
