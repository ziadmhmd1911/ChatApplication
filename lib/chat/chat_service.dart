import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Me.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send Message
  Future<void> SendMessage(String recevierId, String Message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Mo newMessage = Mo(
      senderId: currentUserId,
      senderEmail: currentEmail,
      receiverId: recevierId,
      message: Message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, recevierId];
    ids.sort();

    String chatRoomId = ids.join(
      "_"
    );

    await _firestore
      .collection("chatRooms")
      .doc(chatRoomId)
      .collection("messages")
      .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();

    String chatRoomId = ids.join("_");

    return _firestore
      .collection("chatRooms")
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("timestamp", descending: true)
      .snapshots();  
  }
}