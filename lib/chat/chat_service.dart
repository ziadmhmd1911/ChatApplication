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
    //Get Current User Name form database
    //Get Receiver Name form database
    final DocumentSnapshot currentUserSnapshot = await _firestore
      .collection("users")
      .doc(currentUserId)
      .get();
    
    final String currentUserName = currentUserSnapshot["full_name"];

    final DocumentSnapshot receiverUserSnapshot = await _firestore
      .collection("users")
      .doc(recevierId)
      .get();
    
    final String receiverUserName = receiverUserSnapshot["full_name"];

    final Timestamp timestamp = Timestamp.now();

    Mo newMessage = Mo(
      senderId: currentUserId,
      senderEmail: currentEmail,
      receiverId: recevierId,
      message: Message,
      timestamp: timestamp,
      senderName: currentUserName,
      receiveName: receiverUserName,
    );

    List<String> Ids = [currentUserId, recevierId];
    Ids.sort();

    String chatRoomId = Ids.join(
      "_"
    );

    await _firestore
      .collection("chatRooms")
      .doc(chatRoomId)
      .collection("messages")
      .add(newMessage.toMap());

      await _firestore
        .collection("chatRooms")
        .doc(chatRoomId)
        .set({
          "participants": [currentUserName, receiverUserName],
          "lastMessage": Message,
          "timestamp": timestamp,
    }, SetOptions(merge: true));
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