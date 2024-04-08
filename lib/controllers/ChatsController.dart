import 'package:flutter_application_1/models/Chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/loggedUser.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


class ChatsController {
  

  final CollectionReference chatRooms = FirebaseFirestore.instance.collection('chatRooms');
  LoggedUser loggedUser = LoggedUser();

  Future<List<Chats>> getChats(String user) async {
    QuerySnapshot snapshot = await chatRooms
      .where('participants', arrayContains: user)
      .orderBy('lastMessageTime', descending: true)
      .get();
    List<Chats> chatList = [];
    snapshot.docs.forEach((doc) {
      Chats chat = Chats(participants: doc['participants'].cast<String>(), 
                         lastMessage: doc['lastMessage'], 
                         lastMessageTime: doc['lastMessageTime'].toDate()
                        );
      chatList.add(chat);
    });
    return chatList;
  }


  Future<void> createChatWithMessage(String sender, String receiver, String messageText) {
    // Create a new chat document in 'chatRooms' collection
    chatRooms.add({
      'participants': [sender, receiver],
      'lastMessage': messageText,
      'lastMessageTime': DateTime.now()
    }).then((docRef) {
      // Add the first message to this chat's 'messages' subcollection
      docRef.collection('messages').add({
        'sender': sender,
        'receiver': receiver,
        'text': messageText,
        'time': DateTime.now(),
      }).then((value) => print('message added successfully')).catchError((error) => print(error));
    }).catchError((error) => print(error));
    return Future(() => null);
  }
}

// create main function to test the code
void main() async {
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ChatsController chatsController = ChatsController();

  /*// Test createChatWithMessage
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();*/

  // Test getChats
  List<Chats> chatList = await chatsController.getChats();
  chatList.forEach((chat) {
    print(chat.participants);
    print(chat.lastMessage);
    print(chat.lastMessageTime);
  });
}