import 'package:cloud_firestore/cloud_firestore.dart';

class Mo {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String senderName;
  final String receiveName;
  Mo({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.senderName,
    required this.receiveName,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'senderName': senderName,
      'receiveName': receiveName,
    };
  }
}